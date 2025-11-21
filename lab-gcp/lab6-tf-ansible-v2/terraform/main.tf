terraform {
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

resource "google_compute_network" "vpc" {
  name                    = "lab6-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "lab6-subnet"
  region        = var.region
  ip_cidr_range = "10.20.0.0/16"
  network       = google_compute_network.vpc.id
}

resource "google_compute_firewall" "allow_http" {
  name    = "lab6-allow-http"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "web" {
  name         = "lab6-web"
  zone         = var.zone
  machine_type = var.vm_machine_type

  boot_disk {
    initialize_params {
      image = var.vm_image
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.name
    access_config {}
  }
}

resource "google_compute_instance" "db" {
  name         = "lab6-db"
  zone         = var.zone
  machine_type = var.vm_machine_type

  boot_disk {
    initialize_params {
      image = var.vm_image
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.name
    access_config {}
  }
}
resource "null_resource" "run_ansible" {
  depends_on = [
    google_compute_instance.web,
    google_compute_instance.db
  ]

  provisioner "local-exec" {
    command = "cd ../ansible && bash run_ansible.sh"
  }
}

