resource "google_compute_network" "net" {
  name = "rke2-net"
  project = var.project_id
}

resource "google_compute_subnetwork" "subnet" {
  name          = "rke2-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.net.id
  project       = var.project_id
}

resource "google_compute_firewall" "firewall" {
  name    = "rke2-firewall"
  network = google_compute_network.net.name
  project       = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "6443", "9345"]
  }

  source_ranges = ["0.0.0.0/0"]
}
