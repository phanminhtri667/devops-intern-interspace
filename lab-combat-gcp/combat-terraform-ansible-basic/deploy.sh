#!/bin/bash

echo "=== STEP 1: Terraform init + apply ==="
cd terraform
terraform init
terraform apply -auto-approve

echo "=== STEP 2: Generate Ansible Inventory ==="
cd ../ansible
./generate_inventory.sh

echo "=== STEP 3: Run Ansible Playbook ==="
ansible-playbook -i inventory.ini playbook.yml

echo "=== DONE! Entire Infrastructure + App Deployed Successfully ==="
