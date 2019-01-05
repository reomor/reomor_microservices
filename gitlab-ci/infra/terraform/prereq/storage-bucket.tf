resource "google_storage_bucket" "gitlab_state_bucket" {
  
  name = "gitlab-terraform-state-storage-bucket"

  versioning {
    enabled = true
  }

  force_destroy = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_storage_bucket_acl" "state_storage_bucket_acl" {
  bucket         = "${google_storage_bucket.gitlab_state_bucket.name}"
  predefined_acl = "private"
}
