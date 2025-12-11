#!/bin/bash

echo "=== STEP 1: Terraform init + apply ==="
cd terraform || exit 1
terraform init
terraform apply -auto-approve || exit 1

cd - || exit 1
echo "=== STEP 2: Generate Ansible Inventory ==="
cd ansible || exit 1
./generate_inventory.sh || exit 1

echo "=== STEP 3: Run Ansible Playbook ==="
ANSIBLE_SSH_ARGS="-o StrictHostKeyChecking=no" ansible-playbook -i inventory.ini playbook.yml || exit 1

echo "=== DONE! Entire Infrastructure + App Deployed Successfully ==="
