module "gke" {
  source = "terraform-google-modules/kubernetes-engine/google"
  version = " >= 11.0.0"

  project_id = var.gcp_project
  name = "zoover-assignment-gke"
  region = var.gcp_region
  zones = ["europe-west4-b"]

  network = module.vpc.network_name
  subnetwork = module.vpc.subnets_names[0]
  ip_range_pods = module.vpc.subnets_secondary_ranges[0].0.range_name
  ip_range_services = module.vpc.subnets_secondary_ranges[0].1.range_name

  grant_registry_access = true

  regional = false # Zonal for Free Tier
  http_load_balancing = true
  horizontal_pod_autoscaling = true
  network_policy = true

  node_pools = [
    {
      name = "zoover-node-pool"
      machine_type = "e2-standard-2" # f1-micro is not supported
      min_count = 1
      max_count = 3
      initial_node_count = 1 # Defaults to min_count
      autoscaling = true
      local_ssd_count = 0
      disk_size_gb = 50
      disk_type = "pd-standard"
      image_type = "COS" # Container Optimized OS
      auto_repair = true
      auto_upgrade = false
      service_account = var.service_account
      preemptible = false
    }
  ]

  node_pools_oauth_scopes = {
    all = []

    zoover-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    zoover-node-pool = {
      zoover-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    zoover-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_tags = {
    all = []

    zoover-node-pool = [
      "zoover-node-pool",
    ]
  }
}

resource "google_compute_global_address" "zoover_ingress_ip" {
  name = "zoover-ingress-ip"
}
