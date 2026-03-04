variable "project_id"      { default = "devops-workspace-478502" }
variable "region"          { default = "asia-southeast1" }
variable "zone"            { default = "asia-southeast1-b" }

variable "vpc_name"        { default = "vpc-jenkins-pipeline1112" }
variable "subnet_name"     { default = "sub-jenkins-pipeline1112" }
variable "subnet_cidr"     { default = "10.1.0.0/16" }

variable "name_firewall_http"     { default = "allow-http-jenkins1112"}
variable "name_firewall_8080"     { default = "allow-port8080-jenkins1112"}
variable "name_firewall_ssh"      { default = "allow-ssh-jenkins1112"}

variable "vm_machine_type" { default = "e2-medium" }
variable "vm_image"        { default = "ubuntu-os-cloud/ubuntu-2204-lts" }
variable "public_key_path" { default = "/home/pmt/.ssh/id_ed25519.pub" }

variable "master_vm_name" { default = "jenkins-master" }
variable "agent_vm_name"  { default = "jenkins-agent" }