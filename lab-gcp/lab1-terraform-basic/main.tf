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
  project     = var.project_id
  region      = var.region
}


resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
}


resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
}


resource "google_compute_instance" "vm" {
  count        = var.vm_count
  name         = "${var.vm_name_prefix}-${count.index}"
  machine_type = var.vm_machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.vm_image
    }
  }

  network_interface {
    subnetwork    = google_compute_subnetwork.subnet.id
    access_config {}  
  }
}
