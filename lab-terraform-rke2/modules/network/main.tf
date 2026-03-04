resource "google_compute_network" "vpc" {
  name                    = "rke2-vpc-29122025"
  auto_create_subnetworks = true
}

output "network_id" {
  value = google_compute_network.vpc.id
}
