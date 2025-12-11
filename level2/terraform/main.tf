terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    local = {
      source = "hashicorp/local"
    }
    template = {
      source = "hashicorp/template"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
#software catelog
# -------------------------
# NETWORK
# -------------------------
resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
}

# -------------------------
# FIREWALL
# -------------------------
resource "google_compute_firewall" "allow_http" {
  name    = var.firewall_http_name
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_jenkins_8080" {
  name    = var.firewall_8080_name
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = var.firewall_ssh_name
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}


# -------------------------
# VM MASTER
# -------------------------
resource "google_compute_instance" "vm_master" {
  name         = var.master_vm_name
  machine_type = var.vm_machine_type
  zone         = var.zone

  boot_disk {
    initialize_params { image = var.vm_image }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {} # public ip
  }

  metadata = {
    ssh-keys = "pmt:${file(var.public_key_path)}"
  }
}

# -------------------------
# VM AGENT
# -------------------------
resource "google_compute_instance" "vm_agent" {
  name         = var.agent_vm_name
  machine_type = var.vm_machine_type
  zone         = var.zone

  boot_disk {
    initialize_params { image = var.vm_image }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {} # public ip
  }

  metadata = {
    ssh-keys = "pmt:${file(var.public_key_path)}"
  }
}

# -------------------------
# GENERATE INVENTORY
# -------------------------
data "template_file" "inventory" {
  template = file("${path.root}/../ansible/inventory.tpl")

  vars = {
    master_ip         = google_compute_instance.vm_master.network_interface[0].access_config[0].nat_ip
    agent_ip          = google_compute_instance.vm_agent.network_interface[0].access_config[0].nat_ip
    master_private_ip = google_compute_instance.vm_master.network_interface[0].network_ip
    agent_private_ip  = google_compute_instance.vm_agent.network_interface[0].network_ip
  }
}

resource "local_file" "inventory_file" {
  filename = "${path.root}/../ansible/inventory.ini"
  content  = data.template_file.inventory.rendered
}
