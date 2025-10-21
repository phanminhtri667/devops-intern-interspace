terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "devops-workspace-469715"
  region  = var.region
}
# provider "aws" {
#   region = "ap-southeast-1"
# }

# Network
resource "google_compute_network" "devops_net" {
  name = "devops-rke2-network"
}

resource "google_compute_subnetwork" "devops_subnet" {
  name          = "devops-rke2-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.devops_net.id
}

# Master node
resource "google_compute_instance" "master" {
  count        = var.master_count
  name         = "rke2-master-${count.index}"
  machine_type = var.master_instance
  zone         = "${var.region}-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
    }
  }

  network_interface {
    network    = google_compute_network.devops_net.name
    subnetwork = google_compute_subnetwork.devops_subnet.name
    access_config {}
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_key_path)}"
  }

  tags = ["rke2-master"]
}

# Worker node
resource "google_compute_instance" "worker" {
  count        = var.worker_count
  name         = "rke2-worker-${count.index}"
  machine_type = var.worker_instance
  zone         = "${var.region}-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
    }
  }

  network_interface {
    network    = google_compute_network.devops_net.name
    subnetwork = google_compute_subnetwork.devops_subnet.name
    access_config {}
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_key_path)}"
  }

  tags = ["rke2-worker"]
}

