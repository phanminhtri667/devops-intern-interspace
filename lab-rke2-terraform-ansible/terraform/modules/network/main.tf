resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.subnet_cidr
}

# -------------------------
# FIREWALLS (NEEDED FOR PIPELINE)
# -------------------------

# 1) SSH from anywhere (lab). For better security, replace with your public IP /32.
resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.vpc_name}-allow-ssh"
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# 2) Allow internal communication inside subnet (VERY IMPORTANT)
# This lets nodes talk to each other freely (tcp/udp/icmp) within 10.1.0.0/16
resource "google_compute_firewall" "allow_internal" {
  name    = "${var.vpc_name}-allow-internal"
  network = google_compute_network.vpc.id

  allow { protocol = "tcp" }
  allow { protocol = "udp" }
  allow { protocol = "icmp" }

  source_ranges = [var.subnet_cidr]
}

# 3) RKE2 / Kubernetes core ports (intra-cluster)
resource "google_compute_firewall" "allow_rke2_core" {
  name    = "${var.vpc_name}-allow-rke2-core"
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports = [
      "9345",   # rke2 supervisor
      "6443",   # kube-apiserver
      "10250",   # kubelet
      "8080"
    ]
  }

  allow {
    protocol = "udp"
    ports = [
      "8472"    # flannel VXLAN
    ]
  }

  source_ranges = [var.subnet_cidr]
  target_tags   = ["rke2"]
}

# (Optional) Expose Kubernetes API publicly for testing.
# Not recommended unless you know what you're doing.
resource "google_compute_firewall" "allow_k8s_api_public" {
  count   = var.expose_k8s_api ? 1 : 0
  name    = "${var.vpc_name}-allow-k8s-api-public"
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["6443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["master"]
}



resource "google_compute_firewall" "allow_nodeport" {
  name    = "allow-nodeport"
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["rke2"]
}