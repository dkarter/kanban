output "cluster_id" {
  description = "The ID of the created GKE cluster"
  value       = google_container_cluster.primary.id
}

output "cluster_name" {
  description = "The name of the created GKE cluster"
  value       = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  description = "The endpoint for the GKE cluster API server"
  value       = google_container_cluster.primary.endpoint
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "The public certificate authority of the cluster (base64 encoded)"
  value       = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
  sensitive   = true
}

output "node_pool_id" {
  description = "The ID of the created node pool"
  value       = google_container_node_pool.primary_nodes.id
}

output "region" {
  description = "The region of the GKE cluster"
  value       = var.region
}