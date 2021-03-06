variable project {
  description = "Project ID"
}
variable region {
  description = "Region"
  # Значение по умолчанию
  default = "europe-west1"
}
variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable disk_image {
  description = "Disk image"
}
variable zone {
  default = "europe-west1-b"
}
variable private_key {
  description = "Path to the private key used for ssh access"
}
variable instance_count {
  description = "number of instances"
  default     = "1"
}
variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}
variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}
#variable install_app {
#  description = "Decides to install or not install reddit ruby app"
#  default     = false
#}
