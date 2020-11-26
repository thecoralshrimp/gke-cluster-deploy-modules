#=======================================================
# Outputs
#=======================================================
output "gke-endpoint" {
  value = google_container_cluster.gke-cluster.endpoint
}

output "cluster" {
  value = google_container_cluster.gke-cluster
}
