variable "project_id"      { default = "devops-workspace-478502" }
variable "region"          { default = "asia-southeast1" }
variable "zone"            { default = "asia-southeast1-b" }

# Network
variable "vpc_name"        { default = "vpc-jenkins-v3" }
variable "subnet_name"     { default = "subnet-jenkins-v3" }
variable "subnet_cidr"     { default = "10.1.0.0/16" }

# Firewall rules
variable "firewall_http_name"     { default = "allow-http" }
variable "firewall_8080_name"     { default = "allow-jenkins-8080" }
variable "firewall_ssh_name"      { default = "allow-ssh" }

# VM defaults
variable "vm_machine_type" { default = "e2-medium" }
variable "vm_image"        { default = "ubuntu-os-cloud/ubuntu-2204-lts" }
variable "public_key_path" { default = "/home/pmt/.ssh/id_ed25519.pub" }

# VM names
variable "master_vm_name"  { default = "jenkins-master-v3" }
variable "agent_vm_name"   { default = "jenkins-agent-v3" }
