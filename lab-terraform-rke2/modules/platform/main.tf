resource "null_resource" "argocd" {

  provisioner "remote-exec" {
    inline = [
      "export KUBECONFIG=/etc/rancher/rke2/rke2.yaml",
      "kubectl create namespace argocd || true",
      "kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = var.master_ip
      private_key = file("/home/pmt/.ssh/id_ed25519")
    }
  }
}
