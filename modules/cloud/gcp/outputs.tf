output "cluster_id" {
  description = "The ID of the created GKE cluster"
  value       = module.kanban_k8s_cluster.cluster_id
}

output "cluster_name" {
  description = "The name of the created GKE cluster"
  value       = module.kanban_k8s_cluster.cluster_name
}

output "cluster_endpoint" {
  description = "The endpoint for the GKE cluster API server"
  value       = module.kanban_k8s_cluster.cluster_endpoint
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "The public certificate authority of the cluster (base64 encoded)"
  value       = module.kanban_k8s_cluster.cluster_ca_certificate
  sensitive   = true
}

output "region" {
  description = "The region of the GKE cluster"
  value       = module.kanban_k8s_cluster.region
}