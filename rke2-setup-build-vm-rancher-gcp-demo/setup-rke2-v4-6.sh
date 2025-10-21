#!/usr/bin/env bash
set -euo pipefail

### === CONFIG === ###
PROJECT_ID="devops-workspace-469715"
REGION="us-central1"
ZONE="us-central1-a"
NETWORK="devops-intern"
SUBNET="devops-subnet"
MASTER_NAME="rke2-master"
WORKER_COUNT=${1:-1}  # ./setup-rke2.sh 3
MASTER_TYPE="e2-medium"
WORKER_TYPE="e2-medium"

echo "🚀 RKE2 auto-deployment started (v4.6)"
echo "Target: 1 master + $WORKER_COUNT worker(s)"

### === CREATE VPC + FIREWALL === ###
if ! gcloud compute networks describe $NETWORK >/dev/null 2>&1; then
  echo "==> Creating VPC $NETWORK ..."
  gcloud compute networks create $NETWORK --subnet-mode=custom
  gcloud compute networks subnets create $SUBNET \
    --network=$NETWORK --range=10.0.0.0/24 --region=$REGION
  gcloud compute firewall-rules create allow-rke2 \
    --network=$NETWORK --allow tcp:22,tcp:6443,tcp:9345,icmp --source-ranges=0.0.0.0/0
else
  echo "==> VPC $NETWORK already exists. Skipping."
fi

### === CREATE MASTER === ###
if ! gcloud compute instances describe $MASTER_NAME --zone=$ZONE >/dev/null 2>&1; then
  echo "==> Creating master node..."
  gcloud compute instances create $MASTER_NAME \
    --project=$PROJECT_ID --zone=$ZONE \
    --machine-type=$MASTER_TYPE \
    --subnet=$SUBNET --network=$NETWORK \
    --image-family=ubuntu-2204-lts --image-project=ubuntu-os-cloud \
    --tags=rke2 \
    --metadata=startup-script='#!/bin/bash
set -eux
curl -sfL https://get.rke2.io | sh -
systemctl enable --now rke2-server
ln -sf /var/lib/rancher/rke2/bin/kubectl /usr/local/bin/kubectl
mkdir -p /root/.kube
cp /etc/rancher/rke2/rke2.yaml /root/.kube/config || true
echo "export KUBECONFIG=/etc/rancher/rke2/rke2.yaml" >> /etc/profile.d/rke2.sh
'
else
  echo "==> Master already exists. Skipping creation."
fi

MASTER_IP=$(gcloud compute instances describe $MASTER_NAME --zone=$ZONE --format='get(networkInterfaces[0].networkIP)')
echo "Master internal IP: $MASTER_IP"

### === WAIT MASTER (MAX 10 MINUTES) === ###
echo "==> Waiting for RKE2 master to initialize..."
for i in {1..30}; do
  if gcloud compute ssh $MASTER_NAME --zone=$ZONE \
    --command "sudo test -f /var/lib/rancher/rke2/server/node-token" >/dev/null 2>&1; then
    echo "✅ Master is ready!"
    break
  fi
  echo "⏳ Waiting... ($i/30)"
  gcloud compute ssh $MASTER_NAME --zone=$ZONE \
    --command "sudo journalctl -u rke2-server -n 5 --no-pager || true" || true
  sleep 20
  if [[ $i -eq 30 ]]; then
    echo "❌ Timeout: Master did not finish initialization in 10 min."
    exit 1
  fi
done

TOKEN=$(gcloud compute ssh $MASTER_NAME --zone=$ZONE \
  --command "sudo cat /var/lib/rancher/rke2/server/node-token")

echo "TOKEN=$TOKEN"

### === CHECK EXISTING WORKERS === ###
existing_workers=$(gcloud compute instances list --filter="name~^rke2-worker-" --format="value(name)" | wc -l)

### === SCALE-IN === ###
if (( existing_workers > WORKER_COUNT )); then
  echo "==> Scaling down: hiện có $existing_workers, mục tiêu $WORKER_COUNT"
  to_delete=$((existing_workers - WORKER_COUNT))
  for name in $(gcloud compute instances list --filter="name~^rke2-worker-" --format="value(name)" | sort -r | head -n $to_delete); do
    echo "Deleting $name ..."
    gcloud compute instances delete "$name" --zone=$ZONE -q || true
    gcloud compute ssh $MASTER_NAME --zone=$ZONE \
      --command "sudo KUBECONFIG=/etc/rancher/rke2/rke2.yaml kubectl delete node $name --ignore-not-found=true || true"
  done
  echo "✅ Đã scale in về $WORKER_COUNT worker"
  exit 0
fi

### === SCALE-OUT === ###
start=$((existing_workers + 1))
end=$WORKER_COUNT
for i in $(seq $start $end); do
  WORKER_NAME="rke2-worker-$i"
  echo "==> Creating worker $WORKER_NAME ..."
  gcloud compute instances create $WORKER_NAME \
    --project=$PROJECT_ID --zone=$ZONE \
    --machine-type=$WORKER_TYPE \
    --subnet=$SUBNET --network=$NETWORK \
    --image-family=ubuntu-2204-lts --image-project=ubuntu-os-cloud \
    --tags=rke2 \
    --metadata=startup-script="#!/bin/bash
set -eux
curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE='agent' sh -
mkdir -p /etc/rancher/rke2
cat >/etc/rancher/rke2/config.yaml <<EOF
server: https://${MASTER_IP}:9345
token: ${TOKEN}
EOF
systemctl enable --now rke2-agent
"
done

### === WAIT WORKERS === ###
echo "==> Waiting 2 minutes for workers to join..."
sleep 120

### === CHECK CLUSTER STATUS === ###
echo "==> Checking RKE2 cluster nodes:"
gcloud compute ssh $MASTER_NAME --zone=$ZONE \
  --command "sudo KUBECONFIG=/etc/rancher/rke2/rke2.yaml kubectl get nodes -o wide"

echo "✅ RKE2 Cluster successfully deployed (v4.6)!"
