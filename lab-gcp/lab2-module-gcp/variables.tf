variable "project_id"    { default = "devops-workspace-478502" }
variable "region"        { default = "us-central1" }
variable "zone"          { default = "us-central1-a" }

variable "vpc_name"      { default = "demo-vpc" }
variable "subnet_name"   { default = "demo-subnet" }
variable "subnet_cidr"   { default = "10.10.0.0/16" }

variable "vm_count"      { default = 2 }
variable "vm_name_prefix"{ default = "demo-vm" }
variable "vm_machine_type" { default = "e2-medium" }
variable "vm_image"        { default = "ubuntu-os-cloud/ubuntu-2004-lts" }
