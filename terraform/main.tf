module "network" {
  source      = "./modules/network"
  project_id  = var.project_id
  vpc_name    = var.vpc_name
  subnet_name = var.subnet_name
  subnet_cidr = var.subnet_cidr
  pods_range_cidr = var.pods_range_cidr
  services_range_cidr = var.services_range_cidr
  region      = var.region
}

module "gke" {
  source       = "./modules/gke"
  cluster_name = var.cluster_name
  project_id   = var.project_id
  master_ipv4_cidr_block = var.master_ipv4_cidr_block
  vpc_network  = module.network.vpc_network_id
  vpc_subnetwork = module.network.subnet_id
  pods_secondary_range_name = module.network.pods_range_name
  services_secondary_range_name = module.network.services_range_name
  region       = var.region
  zone         = var.zone
  service_account = var.service_account
  
  
  # Mixed machine type autoscaling configuration
  enable_preemptible = var.enable_preemptible
  working_machine_type = var.working_machine_type
  # database_machine_type = var.database_machine_type

}
