variable project {
  description = "Project ID"
}

variable vm_name {
  description = "Current branch VM name"
}

variable hub_docker_image {
  description = "Docker image to deploy from Hub"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
}
