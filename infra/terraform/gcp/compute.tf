resource "google_compute_instance" "master" {
  count        = var.master_count
  name         = "rke2-master-${count.index}"
  machine_type = var.master_instance
  zone         = "${var.region}-a"
  project      = var.project_id 

  boot_disk {
    initialize_params { image = "ubuntu-os-cloud/ubuntu-2204-lts" }
  }

  network_interface {
    network    = google_compute_network.net.name
    subnetwork = google_compute_subnetwork.subnet.name
    access_config {}
  }

  metadata = { ssh-keys = "ubuntu:${file(var.ssh_key_path)}" }
  tags     = ["rke2-master"]
}

resource "google_compute_instance" "worker" {
  count        = var.worker_count
  name         = "rke2-worker-${count.index}"
  machine_type = var.worker_instance
  zone         = "${var.region}-b"
  project      = var.project_id 

  boot_disk {
    initialize_params { image = "ubuntu-os-cloud/ubuntu-2204-lts" }
  }

  network_interface {
    network    = google_compute_network.net.name
    subnetwork = google_compute_subnetwork.subnet.name
    access_config {}
  }

  metadata = { ssh-keys = "ubuntu:${file(var.ssh_key_path)}" }
  tags     = ["rke2-worker"]
}
