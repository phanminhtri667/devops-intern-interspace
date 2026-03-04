output "rancher_url" {
  value = "https://${module.compute.master_public_ip}"
}
