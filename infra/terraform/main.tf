locals {
  selected_provider = var.cloud_provider
}

# GCP MODULE
module "gcp_infra" {
  count           = local.selected_provider == "gcp" ? 1 : 0
  source          = "./gcp"
  region          = var.region
  project_id      = var.project_id 
  master_count    = var.master_count
  worker_count    = var.worker_count
  master_instance = var.master_instance
  worker_instance = var.worker_instance
  ssh_key_path    = var.ssh_key_path
}

# AWS MODULE
module "aws_infra" {
  count           = local.selected_provider == "aws" ? 1 : 0
  source          = "./aws"
  region          = var.region
  master_count    = var.master_count
  worker_count    = var.worker_count
  master_instance = var.master_instance
  worker_instance = var.worker_instance
  ssh_key_path    = var.ssh_key_path
}

# AZURE MODULE
module "azure_infra" {
  count           = local.selected_provider == "azure" ? 1 : 0
  source          = "./azure"
  region          = var.region
  master_count    = var.master_count
  worker_count    = var.worker_count
  master_instance = var.master_instance
  worker_instance = var.worker_instance
  ssh_key_path    = var.ssh_key_path
}
