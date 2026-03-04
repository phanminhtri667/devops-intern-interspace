resource "null_resource" "install_rke2_master" {

  provisioner "remote-exec" {
    inline = [
      # ===== Fix apt lỗi jammy =====
      "sudo rm -rf /var/lib/apt/lists/*",
      "sudo apt-get clean",
      "sudo apt-get update -y",

      # ===== Install Docker =====
      "curl -sfL https://get.docker.com | sudo sh",
      "sudo systemctl enable docker",
      "sudo systemctl start docker",

      # ===== Install RKE2 =====
      "curl -sfL https://get.rke2.io | sudo sh -",
      "sudo systemctl enable rke2-server",
      "sudo systemctl start rke2-server",

      # ===== Wait for RKE2 ready =====
      "echo 'Waiting for RKE2...'",
      "until sudo test -f /etc/rancher/rke2/rke2.yaml; do sleep 5; done",

      # ===== Set PATH =====
      "echo 'export PATH=$PATH:/var/lib/rancher/rke2/bin' | sudo tee /etc/profile.d/rke2.sh",
      "source /etc/profile.d/rke2.sh",

      # ===== Set kubeconfig permission =====
      "sudo chmod 644 /etc/rancher/rke2/rke2.yaml",

      # ===== Run Rancher =====
      "sudo docker run -d --restart=unless-stopped --privileged -p 80:80 -p 443:443 rancher/rancher:latest"

    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = var.master_ip
      private_key = file("/home/pmt/.ssh/id_ed25519")
    }
  }
}

output "kubeconfig" {
  value = "/etc/rancher/rke2/rke2.yaml"
}
