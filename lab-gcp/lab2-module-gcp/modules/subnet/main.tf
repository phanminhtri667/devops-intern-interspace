variable "name" {}
variable "cidr" {}
variable "region" {}
variable "network_id" {}

resource "google_compute_subnetwork" "subnet" {
  name          = var.name
  ip_cidr_range = var.cidr
  region        = var.region
  network       = var.network_id
}

output "id" { value = google_compute_subnetwork.subnet.id }
output "cidr" { value = google_compute_subnetwork.subnet.ip_cidr_range }
