variable "project_id"      { default = "devops-workspace-478502" }
variable "region"          { default = "us-central1" }
variable "zone"            { default = "us-central1-a" }

variable "vpc_name"        { default = "test-demo4122025" }
variable "subnet_name"     { default = "sub-test-demo4122025" }
variable "subnet_cidr"     { default = "10.1.0.0/16" }

variable "vm_name"         { default = "vm-test-demo4122025" }
variable "vm_machine_type" { default = "e2-medium" }
variable "vm_image"        { default = "ubuntu-os-cloud/ubuntu-2204-lts" }
variable "public_key_path" { default = "/home/pmt/.ssh/id_ed25519.pub" }

variable "name_firewall_http" { default = "allow-http-test-demo4122025"}
variable "name_firewall_port8080" { default = "allow-port8080-test-demo4122025"}
variable "name_firewall_ssh" { default = "allow-ssh-test-demo4122025"}