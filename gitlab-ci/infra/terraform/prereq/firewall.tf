resource "google_compute_firewall" "gitlab_firewall_puma" {
  name    = "allow-gitlab-puma-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["gitlab-branch"]
}