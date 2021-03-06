#=======================================================
# Outputs
#=======================================================
output "gke-endpoint" {
  value = google_container_cluster.gke-cluster.endpoint
}

output "cluster" {
  value = google_container_cluster.gke-cluster
  sensitive = true
}

output "nodepools" {
  value = google_container_node_pool.gke-node-pool
}
