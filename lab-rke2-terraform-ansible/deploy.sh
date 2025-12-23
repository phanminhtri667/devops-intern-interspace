#!/bin/bash
set -e

export ANSIBLE_HOST_KEY_CHECKING=False

echo "======================================"
echo " Terraform: apply"
echo "======================================"
cd terraform
terraform apply -auto-approve

echo ""
echo "======================================"
echo " Ansible: wait for SSH"
echo "======================================"
cd ../ansible
ansible -i inventory.ini all \
  -m wait_for_connection \
  -a "timeout=600"

echo ""
echo "======================================"
echo " Ansible: wait for cloud-init"
echo "======================================"
ansible -i inventory.ini all \
  -m wait_for \
  -a "path=/var/lib/cloud/instance/boot-finished timeout=600"

echo ""
echo "======================================"
echo " Ansible: install RKE2 + argocd"
echo "======================================"
ansible-playbook -i inventory.ini site.yaml

echo ""
echo "======================================"
echo " DONE"
echo "======================================"
