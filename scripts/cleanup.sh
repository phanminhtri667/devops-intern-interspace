#!/bin/bash
cd ../infra/terraform
terraform destroy -auto-approve
rm -f ../infra/ansible/rke2_token.txt
echo "✅ Cluster destroyed successfully."
