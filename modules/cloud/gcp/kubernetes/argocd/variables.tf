variable "namespace" {
  description = "Kubernetes namespace for Argo CD"
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "Argo CD Helm chart version"
  type        = string
  default     = "5.51.4"  # Change to latest stable version as needed
}

variable "values_file" {
  description = "Path to values.yaml file for Argo CD Helm chart"
  type        = string
  default     = ""
}

variable "expose_ui" {
  description = "Whether to expose Argo CD UI with LoadBalancer"
  type        = bool
  default     = false
}

variable "additional_values" {
  description = "Additional values in YAML format for the Argo CD Helm chart"
  type        = string
  default     = ""
}