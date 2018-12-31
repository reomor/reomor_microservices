provider "google" {
  version = "1.4.0"
  credentials = "${file("./credentials/project.json")}"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_instance" "gitlab-branch" {
  name         = "${var.vm_name}"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["gitlab-branch", "puma-default"]

  metadata {
    ssh-keys = "appuser:${var.public_key_path}"
  }

  boot_disk {
    initialize_params {
      image = "docker-base"
    }
  }

  network_interface {
    network = "default"

    access_config {
      # ephemeral
    }
  }
}
