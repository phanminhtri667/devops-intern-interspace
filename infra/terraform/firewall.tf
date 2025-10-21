  resource "google_compute_firewall" "devops_firewall" {
    name    = "devops-rke2-firewall"
    network = google_compute_network.devops_net.name

    allow {
      protocol = "tcp"
      ports    = ["22", "80", "443", "6443", "9345"]
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["rke2-master", "rke2-worker"]
  }