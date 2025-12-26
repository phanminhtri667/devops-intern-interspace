data "local_file" "ssh_key" {
  filename = var.public_key_path
}

resource "google_compute_network" "vpc" {
  name                    = "rke2-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "rke2-subnet"
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.subnet_cidr
  region        = var.region
}

resource "google_compute_firewall" "rke2" {
  name    = "rke2-firewall"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "6443", "9345"]
  }

  allow {
    protocol = "udp"
    ports    = ["8472"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "master" {
  count        = var.master_count
  name         = "vm-rke2-master-${count.index}"
  machine_type = var.master_machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 50
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${data.local_file.ssh_key.content}"
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    set -e

    curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE=server sh -

    mkdir -p /etc/rancher/rke2
    cat <<EOT > /etc/rancher/rke2/config.yaml
    token: ${var.rke2_token}
    tls-san:
      - 0.0.0.0
    EOT

    systemctl enable rke2-server
    systemctl start rke2-server
  EOF
}

resource "google_compute_instance" "worker" {
  count        = var.worker_count
  name         = "vm-rke2-worker-${count.index}"
  machine_type = var.worker_machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 30
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${data.local_file.ssh_key.content}"
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    set -e

    MASTER_IP="${google_compute_instance.master[0].network_interface[0].network_ip}"

    curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE=agent sh -

    mkdir -p /etc/rancher/rke2
    cat <<EOT > /etc/rancher/rke2/config.yaml
    server: https://${MASTER_IP}:9345
    token: ${var.rke2_token}
    EOT

    systemctl enable rke2-agent
    systemctl start rke2-agent
  EOF

  depends_on = [
    google_compute_instance.master
  ]
}
