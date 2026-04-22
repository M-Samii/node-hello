 output "gke_cluster_name" { value = google_container_cluster.nawy.name }
 output "gke_endpoint" { value = google_container_cluster.nawy.endpoint }
 output "gke_ca_certificate" { value = google_container_cluster.nawy.master_auth.0.cluster_ca_certificate }
