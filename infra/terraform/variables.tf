variable "cloud_provider" {
  description = "Cloud provider: gcp, aws, or azure"
  type = string
}

variable "region" {}
variable "project_id" {}
variable "master_count" { default = 1 }
variable "worker_count" { default = 2 }
variable "master_instance" { default = "e2-medium" }
variable "worker_instance" { default = "e2-small" }
variable "ssh_key_path" { default = "~/.ssh/id_ed25519.pub" }
variable "aws_profile" { default = "default" }
