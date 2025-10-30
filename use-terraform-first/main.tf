terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

provider "google" {
  project = "devops-workspace-469715"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_network" "vpc_network" {
  name = "use-terraform-ansible-first"
}

resource "google_compute_instance" "vm_instance" {
  name         = "vm-terraform-ansible"
  machine_type = "e2-micro"
  tags         = ["web", "dev"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {}
  }

  metadata = {
    ssh-keys = "pmt:${file("~/.ssh/id_ed25519.pub")}"
  }
}

resource "null_resource" "run_ansible" {
  depends_on = [google_compute_instance.vm_instance]

  provisioner "local-exec" {
    command = <<EOT
      echo "Waiting for VM to be ready..."
      sleep 80
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook \
        -i ${google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip}, \
        ../use-ansible-first/playbook.yaml -u pmt
    EOT
  }
}


resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]
}
