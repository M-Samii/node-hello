terraform {
  backend "gcs" {
    bucket = "terraformstatefilenawy"
    prefix = "terraform/state"
  }
}
