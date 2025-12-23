variable "project_id" { default = "devops-workspace-478502" }
variable "region"     { default = "asia-southeast1" }
variable "zone"       { default = "asia-southeast1-b" }

# Network
variable "vpc_name"      { default = "rke2-vpc-172018122025" }
variable "subnet_name"   { default = "rke2-subnet-172018122025" }
variable "subnet_cidr"   { default = "10.1.0.0/16" }

# VM
variable "vm_machine_type" { default = "e2-medium" }
variable "vm_image"        { default = "ubuntu-os-cloud/ubuntu-2204-lts" }

# SSH
variable "ssh_user"        { default = "pmt" }
variable "public_key_path" { default = "/home/pmt/.ssh/id_ed25519.pub" }

# Optional: expose Kubernetes API publicly for testing (NOT recommended for prod)
variable "expose_k8s_api" {
  type    = bool
  default = false
}
