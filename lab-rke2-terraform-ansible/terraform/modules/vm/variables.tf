variable "name" {}
variable "zone" {}
variable "subnet_id" {}
variable "machine_type" {}
variable "image" {}
variable "ssh_user" {}
variable "public_key_path" {}

variable "tags" {
  type    = list(string)
  default = []
}
variable "disk_size" {
  description = "Boot disk size (GB)"
  type        = number
}
