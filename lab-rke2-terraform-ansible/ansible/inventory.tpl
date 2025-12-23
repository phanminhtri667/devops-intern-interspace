[masters]
master-1 ansible_host=${master_ip} ansible_user=pmt private_ip=${master_private}

[workers]
worker-1 ansible_host=${worker_ip} ansible_user=pmt
