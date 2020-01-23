variable public_key_path {
  description = "Path to the public key used to connect to instance"
}
variable zone {
  description = "Zone"
}
variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable "db_external_ip" {
  description = "Reddit DB internal ip"
}

variable provision_enabled {
  default = "false"
}

variable install_app {
  default = false
}
variable private_key {
  description = "Path to the private key used for ssh access"
}
