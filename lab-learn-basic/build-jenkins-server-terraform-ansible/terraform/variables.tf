variable "project_id"      { default = "devops-workspace-478502" }
variable "region"          { default = "us-central1" }
variable "zone"            { default = "us-central1-a" }

variable "vpc_name"        { default = "test-install-jenkins-pipeline0112" }
variable "subnet_name"     { default = "sub-jenkins-pipeline0112" }
variable "subnet_cidr"     { default = "10.1.0.0/16" }

variable "vm_name"         { default = "vm-jenkins-pipeline0112" }
variable "vm_machine_type" { default = "e2-medium" }
variable "vm_image"        { default = "ubuntu-os-cloud/ubuntu-2204-lts" }
variable "public_key_path" { default = "/home/pmt/.ssh/id_ed25519.pub" }

variable "name_firewall_http" { default = "allow-http-install-jenkins0112"}
variable "name_firewall_port8080" { default = "allow-port8080-install-jenkins0112"}
variable "name_firewall_ssh" { default = "allow-ssh-install-jenkins0112"}