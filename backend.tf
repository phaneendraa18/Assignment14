terraform {
  backend "gcs" {
    bucket  = "primarystorage123"
    prefix  = "terraform/state"
  }
}

