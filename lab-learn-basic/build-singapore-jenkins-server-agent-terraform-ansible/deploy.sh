#!/bin/bash
set -e

echo "=== STEP 1: Terraform init + apply ==="
cd terraform
terraform init
terraform apply -auto-approve
cd ..

echo "=== STEP 2: Waiting for VMs boot up (sleep 25s) ==="
sleep 25

echo "=== STEP 3: Run Ansible Playbook ==="
ANSIBLE_SSH_ARGS="-o StrictHostKeyChecking=no" \
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml

echo "=== DONE! Jenkins Master + Agent deployed successfully ==="
