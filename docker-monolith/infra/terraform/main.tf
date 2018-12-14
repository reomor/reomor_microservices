provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_instance" "docker" {
  count        = "${var.count}"
  name         = "docker-${count.index}"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["docker-host"]

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  boot_disk {
    initialize_params {
      image = "${var.base_disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config {
      # ephemeral
    }
  }
}
