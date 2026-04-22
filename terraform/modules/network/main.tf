resource "google_compute_network" "vpc_network" {
    name                      = var.vpc_name
    auto_create_subnetworks = false
    project                 = var.project_id
    routing_mode             = "REGIONAL"
}
resource "google_compute_subnetwork" "private_subnet" {
    name          = var.subnet_name
    ip_cidr_range = var.subnet_cidr
    region        = var.region
    network       = google_compute_network.vpc_network.id
    private_ip_google_access = true
    project       = var.project_id

    secondary_ip_range {
        range_name    = "pods"
        ip_cidr_range = var.pods_range_cidr
    }

    secondary_ip_range {
        range_name    = "services"
        ip_cidr_range = var.services_range_cidr
    }

}

resource "google_compute_firewall" "internal" {
  name    = "${var.vpc_name}-internal"
  network = google_compute_network.vpc_network.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  source_ranges = [var.subnet_cidr,var.services_range_cidr,var.pods_range_cidr]
}

resource "google_compute_router" "router" {
  name    = "${var.vpc_name}-router"
  network = google_compute_network.vpc_network.name
  region  = var.region
  project = var.project_id
}

resource "google_compute_router_nat" "nat" {
  name   = "${var.vpc_name}-nat"
  router = google_compute_router.router.name
  region = var.region
  project = var.project_id
  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  log_config {
    enable = true
    filter = "ALL"
  }

}