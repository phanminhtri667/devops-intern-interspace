#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

source ./parse-config.sh
cd ../infra/terraform

echo "🚀 Starting Terraform apply..."
terraform init -input=false
terraform apply -auto-approve \
  -var="cloud_provider=$PROVIDER" \
  -var="project_id=$PROJECT_ID" \
  -var="region=$REGION" \
  -var="master_count=$MASTER_COUNT" \
  -var="worker_count=$WORKER_COUNT" \
  -var="master_instance=$MASTER_TYPE" \
  -var="worker_instance=$WORKER_TYPE" \
  -var="ssh_key_path=$SSH_KEY_PATH" \
  -var="aws_profile=$AWS_PROFILE"


MASTER_IP=$(terraform output -json master_ips | jq -r '.[0]')
WORKER_IPS=$(terraform output -json worker_ips | jq -r '.[]')

cd ../ansible
echo "[master]" > inventory.ini
echo "${MASTER_IP} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_ed25519" >> inventory.ini
echo "" >> inventory.ini
echo "[worker]" >> inventory.ini
for ip in $WORKER_IPS; do
  echo "${ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_ed25519" >> inventory.ini
done

ansible-playbook -i inventory.ini setup-rke2.yml
ssh -i ~/.ssh/id_ed25519 ubuntu@$MASTER_IP "sudo KUBECONFIG=/etc/rancher/rke2/rke2.yaml kubectl get nodes -o wide"
