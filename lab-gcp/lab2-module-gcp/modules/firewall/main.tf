variable "name" {}
variable "network" {}
variable "allowed_ports" {
  type = list(object({
    protocol = string
    ports    = list(string)
  }))
}

resource "google_compute_firewall" "firewall" {
  name    = var.name
  network = var.network

  allow {
    protocol = "icmp"
  }

  dynamic "allow" {
    for_each = var.allowed_ports
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  source_ranges = ["0.0.0.0/0"]
}

output "name" { value = google_compute_firewall.firewall.name }
