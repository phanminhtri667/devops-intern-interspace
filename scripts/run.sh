#!/usr/bin/env bash
set -euo pipefail
export ANSIBLE_HOST_KEY_CHECKING=False

cd "$(dirname "$0")/../infra/terraform"

echo "=== [1/3] Terraform apply ==="
terraform init -input=false
terraform apply -auto-approve

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

echo "=== [2/3] Ansible setup ==="
ansible-playbook -i inventory.ini setup-rke2.yml

echo "=== [3/3] Verification ==="
ssh -i ~/.ssh/id_ed25519 ubuntu@$MASTER_IP "sudo KUBECONFIG=/etc/rancher/rke2/rke2.yaml kubectl get nodes -o wide"
