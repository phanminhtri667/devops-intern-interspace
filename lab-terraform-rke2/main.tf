module "network" {
  source = "./modules/network"
  region = var.region
}

module "firewall" {
  source     = "./modules/firewall"
  network_id = module.network.network_id
}

module "compute" {
  source         = "./modules/compute"
  zone           = var.zone
  network_id     = module.network.network_id
  ssh_user       = var.ssh_user
  ssh_public_key = var.ssh_public_key
  master_vm      = var.master_vm
  worker_vms     = var.worker_vms
}

module "rke2" {
  source     = "./modules/rke2"
  master_ip  = module.compute.master_public_ip
  worker_ips = module.compute.worker_public_ips
}

module "platform" {
  source    = "./modules/platform"
  master_ip = module.compute.master_public_ip
}

