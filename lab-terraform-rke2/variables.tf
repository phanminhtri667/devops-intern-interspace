variable "project_id" { default = "devops-workspace-478502" }
variable "region" { default = "asia-southeast1" }
variable "zone" { default = "asia-southeast1-a" }
variable "ssh_user" { default = "ubuntu" }
variable "ssh_public_key" { default = "/home/pmt/.ssh/id_ed25519.pub" }

variable "master_vm" {
  type = object({
    name         = string
    machine_type = string
  })
  default = {
    name         = "rke2-master"
    machine_type = "e2-standard-2"
  }
}

variable "worker_vms" {
  type = map(object({
    machine_type = string
  }))
  default = {
    worker-1 = { machine_type = "e2-medium" }
    worker-2 = { machine_type = "e2-medium" }
  }
}
