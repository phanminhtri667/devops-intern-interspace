variable "vpc_name" {}
variable "subnet_name" {}
variable "subnet_cidr" {}
variable "region" {}

variable "expose_k8s_api" {
  type    = bool
  default = false
}
