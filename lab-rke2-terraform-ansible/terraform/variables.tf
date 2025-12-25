variable "project_id" { default = "devops-workspace-478502" }
variable "region"     { default = "asia-southeast1" }
variable "zone"       { default = "asia-southeast1-b" }

# Network
variable "vpc_name"      { default = "rke2-vpc-172018122025" }
variable "subnet_name"   { default = "rke2-subnet-172018122025" }
variable "subnet_cidr"   { default = "10.1.0.0/16" }

# VM MASTER
variable "master_machine_type" {
  description = "Machine type for RKE2 master"
  default     = "e2-standard-2" # 2 vCPU, 8GB RAM
}
variable "master_disk_size" {
  description = "Disk size for RKE2 master"
  default     = 40
}
# VM WORKER
variable "worker_machine_type" {
  description = "Machine type for RKE2 worker"
  default     = "e2-medium" # 2 vCPU, 4GB RAM
}
variable "worker_disk_size" {
  description = "Disk size for RKE2 worker"
  default     = 30
}
# VM Image
variable "vm_image" {
  description = "Base image for VM"
  default     = "ubuntu-os-cloud/ubuntu-2204-lts"
}

# SSH
variable "ssh_user"        { default = "pmt" }
variable "public_key_path" { default = "/home/pmt/.ssh/id_ed25519.pub" }

# Optional: expose Kubernetes API publicly for testing (NOT recommended for prod)
variable "expose_k8s_api" {
  type    = bool
  default = false
}
