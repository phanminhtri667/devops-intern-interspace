output "master_ips" {
  description = "Public IPs of master nodes"
  value = flatten([
    module.gcp_infra[*].master_ips,
    module.aws_infra[*].master_ips,
    module.azure_infra[*].master_ips
  ])
}

output "worker_ips" {
  description = "Public IPs of worker nodes"
  value = flatten([
    module.gcp_infra[*].worker_ips,
    module.aws_infra[*].worker_ips,
    module.azure_infra[*].worker_ips
  ])
}
