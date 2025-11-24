#!/bin/bash

echo "=== 1. Terraform Init & Apply ==="
cd terraform
terraform init -upgrade
terraform apply -auto-approve

echo "=== 2. Generate Inventory ==="
cd ../ansible
chmod +x generate_inventory.sh
./generate_inventory.sh

echo "=== 3. Run Ansible Playbook ==="
ansible-playbook -i inventory.ini playbook.yml
