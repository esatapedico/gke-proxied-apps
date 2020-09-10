output "global_ip_address" {
  description = "Ip address for the zoover-ingress-service"
  value = google_compute_global_address.zoover_ingress_ip.address
}
