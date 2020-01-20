terraform {
  backend "gcs" {
    bucket = "storage-bucket-tokin"
    prefix = "tf-state-stage"
  }
}
