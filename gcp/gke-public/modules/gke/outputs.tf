# Output the GKE cluster endpoint (API server endpoint)
output "cluster_endpoint" {
  description = "The endpoint of the GKE cluster."
  value       = google_container_cluster.gke_cluster.endpoint
}

# Output the GKE cluster name
output "cluster_name" {
  description = "The name of the GKE cluster."
  value       = google_container_cluster.gke_cluster.name
}

# Output the primary node pool name
output "primary_node_pool_name" {
  description = "The name of the primary node pool."
  value       = google_container_node_pool.primary_pool.name
}

# Output the separate node pool name
output "separate_node_pool_name" {
  description = "The name of the separate node pool."
  value       = google_container_node_pool.separate_pool.name
}

# Output the GKE cluster's full configuration
output "gke_endpoint" {
  description = "The full GKE cluster resource."
  value       = google_container_cluster.gke_cluster
}
