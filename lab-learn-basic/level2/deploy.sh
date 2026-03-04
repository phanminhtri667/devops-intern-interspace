#!/bin/bash
set -e

echo "=== STEP 1: Terraform init + apply ==="
cd terraform
terraform init
terraform apply -auto-approve
cd ..

echo "=== STEP 2: Wait VM boot ==="
sleep 40

echo "=== STEP 3: Run Ansible ==="
ANSIBLE_SSH_ARGS="-o StrictHostKeyChecking=no" \
ansible-playbook -i ansible/inventory.ini ansible/playbook.yaml
