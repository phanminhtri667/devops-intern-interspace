variable "project_id" { default = "devops-workspace-478502" }
variable "region"     { default = "asia-southeast1" }
variable "zone"       { default = "asia-southeast1-a" }

variable "vpc_cidr"    { default = "10.20.0.0/16" }
variable "subnet_cidr" { default = "10.20.1.0/24" }

variable "master_count" { default = 1 }
variable "worker_count" { default = 1 }

variable "master_machine_type" { default = "e2-standard-2" }
variable "worker_machine_type" { default = "e2-medium" }

variable "ssh_user"        { default = "pmt" }
variable "public_key_path" { default = "/home/pmt/.ssh/id_ed25519.pub" }

variable "rke2_token" {
  description = "Shared token for RKE2 cluster"
  default     = "rke2-lab-shared-token-123456"
}
