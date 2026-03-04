resource "google_compute_firewall" "allow_rke2" {
  name    = "allow-rke2"
  network = var.network_id

  allow {
    protocol = "tcp"
    ports = [
      "22",
      "6443",
      "2379-2380",
      "10250",
      "30000-32767",
      "80",
      "443"
    ]
  }

  source_ranges = ["0.0.0.0/0"]
}
