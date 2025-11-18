output "vm_names" {
  description = "Danh sách tên các VM"
  value       = google_compute_instance.vm[*].name
}

output "vm_public_ips" {
  description = "Danh sách IP public của các VM"
  value       = [
    for vm in google_compute_instance.vm :
    vm.network_interface[0].access_config[0].nat_ip
  ]
}

output "subnet" {
  value = google_compute_subnetwork.subnet.ip_cidr_range
}

output "vpc_name" {
  value = google_compute_network.vpc.name
}
