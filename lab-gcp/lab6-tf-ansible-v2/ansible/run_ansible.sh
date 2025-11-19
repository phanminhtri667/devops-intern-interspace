#!/bin/bash

WEB_IP=$(terraform -chdir=../terraform output -raw web_ip)
DB_IP=$(terraform -chdir=../terraform output -raw db_ip)

echo "[web]" > inventory.ini
echo "webserver ansible_host=$WEB_IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa" >> inventory.ini

echo "" >> inventory.ini
echo "[db]" >> inventory.ini
echo "dbserver ansible_host=$DB_IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa" >> inventory.ini

ansible-playbook -i inventory.ini playbook.yml
