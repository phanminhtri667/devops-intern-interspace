#!/usr/bin/env bash
set -euo pipefail

### === CONFIG === ###
PROJECT_ID="devops-workspace-469715"
REGION="us-central1"
ZONE="us-central1-a"
NETWORK="devops-interspace-intern"
SUBNET="devops-subnet"
MASTER_NAME="rke2-master"
WORKER_COUNT=${1:-1}  # Số lượng worker mong muốn (ví dụ: ./setup-rke2.sh 3)

### === CREATE VPC + FIREWALL (if not exists) === ###
if ! gcloud compute networks describe $NETWORK >/dev/null 2>&1; then
  echo "==> Creating VPC $NETWORK ..."
  gcloud compute networks create $NETWORK --subnet-mode=custom
  gcloud compute networks subnets create $SUBNET \
    --network=$NETWORK --range=10.0.0.0/24 --region=$REGION
  gcloud compute firewall-rules create allow-rke2 \
    --network=$NETWORK --allow tcp:22,tcp:6443,tcp:9345,icmp
else
  echo "==> VPC $NETWORK already exists. Skipping."
fi

### === CREATE MASTER === ###
if ! gcloud compute instances describe $MASTER_NAME --zone=$ZONE >/dev/null 2>&1; then
  echo "==> Creating master node..."
  gcloud compute instances create $MASTER_NAME \
    --project=$PROJECT_ID --zone=$ZONE \
    --machine-type=e2-medium \
    --subnet=$SUBNET --network=$NETWORK \
    --image-family=ubuntu-2204-lts --image-project=ubuntu-os-cloud \
    --tags=rke2 \
    --metadata=startup-script='#!/bin/bash
set -eux
curl -sfL https://get.rke2.io | sh -
systemctl enable --now rke2-server
ln -sf /var/lib/rancher/rke2/bin/kubectl /usr/local/bin/kubectl
echo "export KUBECONFIG=/etc/rancher/rke2/rke2.yaml" >> /etc/profile.d/rke2.sh
source /etc/profile.d/rke2.sh
'
else
  echo "==> Master already exists. Skipping creation."
fi

echo "==> Waiting for master to boot (80s)..."
sleep 80

MASTER_IP=$(gcloud compute instances describe $MASTER_NAME --zone=$ZONE \
  --format='get(networkInterfaces[0].networkIP)')
TOKEN=$(gcloud compute ssh $MASTER_NAME --zone=$ZONE --command \
  "sudo cat /var/lib/rancher/rke2/server/node-token")

echo "MASTER_IP=$MASTER_IP"
echo "TOKEN=$TOKEN"

### === CHECK EXISTING WORKERS === ###
existing_workers=$(gcloud compute instances list --filter="name~^rke2-worker-" --format="value(name)" | wc -l)

### === SCALE-IN: GIẢM WORKER (nếu cần) === ###
if (( existing_workers > WORKER_COUNT )); then
  echo "==> Scaling down: hiện có $existing_workers, mục tiêu $WORKER_COUNT"
  to_delete=$((existing_workers - WORKER_COUNT))
  for name in $(gcloud compute instances list --filter="name~^rke2-worker-" --format="value(name)" | sort -r | head -n $to_delete); do
    echo "Deleting $name ..."
    gcloud compute instances delete "$name" --zone=$ZONE -q || true
  done
  echo "✅ Đã scale in về $WORKER_COUNT worker"
  exit 0
fi

### === SCALE-OUT: TẠO THÊM WORKER === ###
start=$((existing_workers + 1))
end=$WORKER_COUNT

for i in $(seq $start $end); do
  WORKER_NAME="rke2-worker-$i"
  echo "==> Creating worker $WORKER_NAME ..."
  gcloud compute instances create $WORKER_NAME \
    --project=$PROJECT_ID --zone=$ZONE \
    --machine-type=e2-medium \
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

echo "==> Waiting for workers to join (80s)..."
sleep 80

### === CHECK CLUSTER STATUS === ###
echo "==> Checking RKE2 cluster nodes:"
gcloud compute ssh $MASTER_NAME --zone=$ZONE \
  --command "sudo KUBECONFIG=/etc/rancher/rke2/rke2.yaml kubectl get nodes -o wide"

echo "✅ RKE2 Cluster updated successfully!"
