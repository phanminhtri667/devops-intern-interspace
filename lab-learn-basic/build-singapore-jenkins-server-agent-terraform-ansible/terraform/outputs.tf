output "master_ip" {
  value = google_compute_instance.vm_master.network_interface[0].access_config[0].nat_ip
}

output "agent_ip" {
  value = google_compute_instance.vm_agent.network_interface[0].access_config[0].nat_ip
}

output "master_name" {
  value = google_compute_instance.vm_master.name
}

output "agent_name" {
  value = google_compute_instance.vm_agent.name
}

output "master_private_ip" {
  value = google_compute_instance.vm_master.network_interface[0].network_ip
}
