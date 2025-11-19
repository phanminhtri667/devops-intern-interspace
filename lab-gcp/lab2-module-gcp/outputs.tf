output "vpc_id" {
  value = module.vpc.id
}

output "subnet_id" {
  value = module.subnet.id
}

output "firewall" {
  value = module.firewall.name
}

output "vm_ips" {
  value = module.vm.public_ips
}

output "vm_names" {
  value = module.vm.names
}
