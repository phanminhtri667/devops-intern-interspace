variable "project_id" {
  default     = "devops-workspace-478502"
}

variable "region" {
  default     = "us-central1"
}

variable "zone" {
  default     = "us-central1-a"
}

variable "vm_count" {
  default     = 1
}

variable "vm_name_prefix" {
  default     = "devops-vm"
}

variable "vm_machine_type" {
  default     = "e2-standard-2"
}

variable "vm_image" {
  default     = "ubuntu-os-cloud/ubuntu-2004-lts"
}

variable "network_name" {
  default     = "lab-gcp"
}

variable "subnet_name" {
  default     = "subnet-lab-gcp"
}

variable "subnet_cidr" {
  default     = "10.0.0.0/16"
}
