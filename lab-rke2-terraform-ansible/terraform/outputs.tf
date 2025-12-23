data "template_file" "inventory" {
  template = file("${path.module}/../ansible/inventory.tpl")

  vars = {
    master_ip      = module.master.public_ip
    worker_ip      = module.worker.public_ip
    master_private = module.master.private_ip
  }
}

resource "local_file" "inventory" {
  filename = "${path.module}/../ansible/inventory.ini"
  content  = data.template_file.inventory.rendered
}

output "master_public_ip" {
  value = module.master.public_ip
}

output "worker_public_ip" {
  value = module.worker.public_ip
}

output "master_private_ip" {
  value = module.master.private_ip
}

output "worker_private_ip" {
  value = module.worker.private_ip
}
