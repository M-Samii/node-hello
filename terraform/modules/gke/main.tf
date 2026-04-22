resource "google_container_cluster" "nawy" {
  name     = var.cluster_name
  location = var.zone  # Use zone instead of region for zonal cluster
  project  = var.project_id
  deletion_protection = false
  network    = var.vpc_network
  subnetwork = var.vpc_subnetwork

  ip_allocation_policy {
    cluster_secondary_range_name = var.pods_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }
  remove_default_node_pool = true
  initial_node_count       = 1

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }
  
}

# working node pool with smaller, cost-effective machines (always running)

resource "google_container_node_pool" "working_nodes" {
  name = "${var.cluster_name}-working-pool"
  location = var.zone
  cluster = google_container_cluster.nawy.name
  project = var.project_id
  initial_node_count = var.working_node_count
  node_config {
    preemptible = var.enable_preemptible
    machine_type = var.working_machine_type
    
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    tags = ["gke-${var.cluster_name}-working-pool"]

    labels = {
      pool_type = "working"
      machine_type = var.working_machine_type
    }

  }
  management {
    auto_repair  = true
    auto_upgrade = true
  }
  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0  # Ensure at least one node is always available
  }
}


