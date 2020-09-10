resource "google_container_registry" "zoover_registry" {
  project  = var.gcp_project
  location = "EU"
}
