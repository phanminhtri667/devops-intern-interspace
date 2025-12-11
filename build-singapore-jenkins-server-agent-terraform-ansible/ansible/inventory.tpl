[jenkins_master]
master ansible_host=${master_ip} private_ip=${master_private_ip} ansible_user=pmt ansible_ssh_private_key_file=~/.ssh/id_ed25519

[jenkins_agent]
agent ansible_host=${agent_ip} private_ip=${master_private_ip} ansible_user=pmt ansible_ssh_private_key_file=~/.ssh/id_ed25519
