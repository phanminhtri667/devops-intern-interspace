variable "zone" {}
variable "network_id" {}
variable "ssh_user" {}
variable "ssh_public_key" {}

variable "master_vm" {
  type = object({
    name         = string
    machine_type = string
  })
}

variable "worker_vms" {
  type = map(object({
    machine_type = string
  }))
}
