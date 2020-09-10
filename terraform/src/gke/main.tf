terraform {
  required_version = ">= 0.13.2"

  required_providers {
    google = ">= 3.37.0"
  }
}

provider "google" {
  credentials = file(var.gcp_auth_file)
  project = var.gcp_project
  region = var.gcp_region
}
