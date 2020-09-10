variable "gcp_auth_file" {
  type = string
  description = "Path for Google Cloud Platform authentication file for service account for project"
}

variable "gcp_region" {
  type = string
  description = "Default region for Google Cloud Platform resoures"
}

variable "gcp_project" {
  type = string
  description = "Google Cloud Platform project name"
}

variable "service_account" {
  type = string
  description = "Service account to be used (must be the same as in the credentials file)"
}
