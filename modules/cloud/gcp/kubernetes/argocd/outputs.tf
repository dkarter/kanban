output "namespace" {
  description = "The Kubernetes namespace where Argo CD is deployed"
  value       = kubernetes_namespace.argocd.metadata[0].name
}

output "release_name" {
  description = "The name of the Helm release"
  value       = helm_release.argocd.name
}

output "admin_password_command" {
  description = "Command to retrieve the Argo CD admin password"
  value       = "kubectl -n ${kubernetes_namespace.argocd.metadata[0].name} get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d"
}

output "port_forward_command" {
  description = "Command to port forward the Argo CD UI"
  value       = "kubectl port-forward svc/argocd-server -n ${kubernetes_namespace.argocd.metadata[0].name} 8080:443"
}