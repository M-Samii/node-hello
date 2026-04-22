output "vpc_network_name" { value = google_compute_network.vpc_network.name }
output "vpc_network_id" { value = google_compute_network.vpc_network.id }
output "subnet_id" {
  value = google_compute_subnetwork.private_subnet.id
}
output "subnet_name" {
  value = google_compute_subnetwork.private_subnet.name
}

output "pods_range_name" {
  value = google_compute_subnetwork.private_subnet.secondary_ip_range[0].range_name
}

output "services_range_name" {
  value = google_compute_subnetwork.private_subnet.secondary_ip_range[1].range_name
}
