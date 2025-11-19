terraform {
  required_version = ">= 1.4"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}


module "vpc" {
  source = "./modules/vpc"
  name   = var.vpc_name
}


module "subnet" {
  source     = "./modules/subnet"
  name       = var.subnet_name
  cidr       = var.subnet_cidr
  region     = var.region
  network_id = module.vpc.id
}


module "firewall" {
  source       = "./modules/firewall"
  name         = "${var.vpc_name}-firewall"
  network      = module.vpc.id
  allowed_ports = [
    { protocol = "tcp", ports = ["22"] },  
    { protocol = "tcp", ports = ["80"] }    
  ]
}


module "vm" {
  source        = "./modules/vm"
  count         = var.vm_count
  name_prefix   = var.vm_name_prefix
  machine_type  = var.vm_machine_type
  zone          = var.zone
  image         = var.vm_image
  subnet_id     = module.subnet.id
}
