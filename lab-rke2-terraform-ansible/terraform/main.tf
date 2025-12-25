module "network" {
  source        = "./modules/network"
  vpc_name      = var.vpc_name
  subnet_name   = var.subnet_name
  subnet_cidr   = var.subnet_cidr
  region        = var.region
  expose_k8s_api = var.expose_k8s_api
}

module "master" {
  source          = "./modules/vm"
  name            = "rke2-master"
  zone            = var.zone
  subnet_id       = module.network.subnet_id

  machine_type    = var.master_machine_type
  disk_size       = var.master_disk_size

  image           = var.vm_image
  ssh_user        = var.ssh_user
  public_key_path = var.public_key_path

  tags = ["rke2", "master"]
}

module "worker" {
  source          = "./modules/vm"
  name            = "rke2-worker"
  zone            = var.zone
  subnet_id       = module.network.subnet_id

  machine_type    = var.worker_machine_type
  disk_size       = var.worker_disk_size

  image           = var.vm_image
  ssh_user        = var.ssh_user
  public_key_path = var.public_key_path

  tags = ["rke2", "worker"]
}
