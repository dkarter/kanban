variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "kanban-cluster"
}

variable "region" {
  description = "The region to host the cluster in"
  type        = string
  default     = "us-central1"
}

variable "network" {
  description = "The VPC network to use for the cluster"
  type        = string
  default     = "default"
}

variable "subnetwork" {
  description = "The subnetwork to use for the cluster"
  type        = string
  default     = "default"
}

variable "private_cluster" {
  description = "Enable private cluster (private nodes)"
  type        = bool
  default     = true
}

variable "node_count" {
  description = "Number of nodes in the node pool"
  type        = number
  default     = 1
}

variable "machine_type" {
  description = "The machine type for the nodes"
  type        = string
  default     = "e2-small"  # 2 vCPU, 2GB memory - cost-efficient option
}

variable "disk_size_gb" {
  description = "Size of the disk attached to each node"
  type        = number
  default     = 20
}

variable "environment" {
  description = "Environment label for the cluster nodes"
  type        = string
  default     = "prod"
}

variable "enable_autoscaling" {
  description = "Enable autoscaling for the node pool"
  type        = bool
  default     = false
}

variable "min_node_count" {
  description = "Minimum number of nodes in the node pool (for autoscaling)"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum number of nodes in the node pool (for autoscaling)"
  type        = number
  default     = 5
}