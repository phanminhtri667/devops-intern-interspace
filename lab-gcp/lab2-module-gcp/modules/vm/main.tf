variable "count" {}
variable "name_prefix" {}
variable "machine_type" {}
variable "zone" {}
variable "image" {}
variable "subnet_id" {}

resource "google_compute_instance" "vm" {
  count        = var.count
  name         = "${var.name_prefix}-${count.index + 1}"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    subnetwork = var.subnet_id
    access_config {}
  }
}

output "names" {
  value = google_compute_instance.vm[*].name
}

output "public_ips" {
  value = [
    for vm in google_compute_instance.vm :
    vm.network_interface[0].access_config[0].nat_ip
  ]
}
