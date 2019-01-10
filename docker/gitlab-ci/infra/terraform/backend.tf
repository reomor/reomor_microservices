terraform {
  backend "gcs" {
    credentials = "./credentials/project.json"
    bucket = "gitlab-terraform-state-storage-bucket"
  }
}