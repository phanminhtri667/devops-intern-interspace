output "master_ips" {
  description = "Public IPs of master nodes"
  value       = google_compute_instance.master[*].network_interface[0].access_config[0].nat_ip
}

output "worker_ips" {
  description = "Public IPs of worker nodes"
  value       = google_compute_instance.worker[*].network_interface[0].access_config[0].nat_ip
}
