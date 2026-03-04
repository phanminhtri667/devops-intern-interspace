#!/bin/bash

IP=$(terraform -chdir=../terraform output -raw vm_public_ip)

echo "[install-jenkins]" > inventory.ini
echo "vm ansible_host=$IP ansible_user=pmt ansible_ssh_private_key_file=~/.ssh/id_ed25519" >> inventory.ini

echo "Generated inventory:"
cat inventory.ini
