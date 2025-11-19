variable "project_id"      { default = "devops-workspace-478502" }
variable "region"          { default = "us-central1" }
variable "zone"            { default = "us-central1-a" }

variable "vpc_name"        { default = "lab5-vpc" }
variable "subnet_name"     { default = "lab5-subnet" }
variable "subnet_cidr"     { default = "10.1.0.0/16" }

variable "vm_name"         { default = "lab5-vm" }
variable "vm_machine_type" { default = "e2-medium" }
variable "vm_image"        { default = "ubuntu-os-cloud/ubuntu-2004-lts" }
