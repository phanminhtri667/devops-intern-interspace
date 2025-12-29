data "local_file" "ssh_key" {
  filename = var.public_key_path
}

resource "google_compute_network" "vpc" {
  name                    = "vpc-rke2-2912"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "rke2-subnet-2912"
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.subnet_cidr
  region        = var.region
}

resource "google_compute_firewall" "rke2" {
  name    = "rke2-firewall-2912"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "6443", "9345", "8443"]
  }

  allow {
    protocol = "udp"
    ports    = ["8472"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "master" {
  count        = var.master_count
  name         = "vm-rke2-master-2912-${count.index}"
  machine_type = var.master_machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 50
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${data.local_file.ssh_key.content}"
  }

  metadata_startup_script = <<-EOF
#!/bin/bash
set -e

# 1. Install RKE2 server
curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE=server sh -

mkdir -p /etc/rancher/rke2
cat <<EOT > /etc/rancher/rke2/config.yaml
token: ${var.rke2_token}
tls-san:
  - 0.0.0.0
EOT

systemctl enable rke2-server
systemctl start rke2-server

# 2. Wait for kubeconfig
until [ -f /etc/rancher/rke2/rke2.yaml ]; do
  sleep 2
done

# 3. Prepare kubeconfig for SSH user (STANDARD WAY)
USER_HOME=$(getent passwd ${var.ssh_user} | cut -d: -f6)
mkdir -p $USER_HOME/.kube

cp /etc/rancher/rke2/rke2.yaml $USER_HOME/.kube/config

chown -R ${var.ssh_user}:${var.ssh_user} $USER_HOME/.kube
chmod 600 $USER_HOME/.kube/config

# 4. Make kubectl global
until [ -f /var/lib/rancher/rke2/bin/kubectl ]; do
  sleep 2
done

ln -sf /var/lib/rancher/rke2/bin/kubectl /usr/local/bin/kubectl

#docker
apt-get update -y
apt-get install -y ca-certificates curl gnupg lsb-release

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  > /etc/apt/sources.list.d/docker.list

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable docker
systemctl start docker

# Run Rancher container
docker run -d \
  --restart=unless-stopped \
  --name rancher \
  -p 8443:443 \
  --privileged \
  rancher/rancher:latest
EOF
}


resource "google_compute_instance" "worker" {
  count        = var.worker_count
  name         = "vm-rke2-worker-2912-${count.index}"
  machine_type = var.worker_machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 30
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${data.local_file.ssh_key.content}"
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    set -e

    MASTER_IP="${google_compute_instance.master[0].network_interface[0].network_ip}"

    curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE=agent sh -

    mkdir -p /etc/rancher/rke2
    cat <<EOT > /etc/rancher/rke2/config.yaml
    server: https://${google_compute_instance.master[0].network_interface[0].network_ip}:9345
    token: ${var.rke2_token}
    EOT

    systemctl enable rke2-agent
    systemctl start rke2-agent
  EOF

  depends_on = [
    google_compute_instance.master
  ]
}
