module "vpc" {
  source = "terraform-google-modules/network/google"
  version = ">= 2.5.0"

  project_id = var.gcp_project
  network_name = "zoover-vpc-01"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name = "zoover-subnet-01"
      subnet_ip = "10.10.10.0/24"
      subnet_region = "europe-west4"
      subnet_private_access = "false"
      subnet_flow_logs = "true"
      description = "Subnet for GKE"
    }
  ]

  secondary_ranges = {
    zoover-subnet-01 = [
      {
        range_name = "zoover-subnet-01-gke-01-pods"
        ip_cidr_range = "192.168.64.0/24"
      },
      {
        range_name = "zoover-subnet-01-gke-01-services"
        ip_cidr_range = "192.168.65.0/24"
      }
    ]
  }

  routes = [
    {
      name = "egress-internet"
      description = "Route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags = "egress-internet"
      next_hop_internet = "true"
    }
  ]
}
