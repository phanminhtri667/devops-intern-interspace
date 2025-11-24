#!/bin/bash

IP=$(terraform -chdir=../terraform output -raw vm_public_ip)

echo "[lab5_vm]" > inventory.ini
echo "vm ansible_host=$IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa" >> inventory.ini

echo "Generated inventory:"
cat inventory.ini
