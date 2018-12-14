variable project {
  description = "Project ID"
}

variable base_disk_image {
  description = "Disk image for reddit app"
  default     = "ubuntu-1604-xenial-v20181204"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable count {
  description = "Number of docker hosts"
  default     = 1
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
}
