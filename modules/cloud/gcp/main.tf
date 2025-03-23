locals {
  project_id = var.project_id
  region     = var.region
}

terraform {
  required_version = "~> 1.10"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.26.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 6.26.0"
    }
  }
}

provider "google" {
  project = local.project_id
  region  = local.region
}

provider "google-beta" {
  project = local.project_id
  region  = local.region
}

# Create GKE cluster using the module
module "kanban_k8s_cluster" {
  source = "./kubernetes"

  project_id   = local.project_id
  cluster_name = var.cluster_name
  region       = local.region

  # Use environment-specific settings
  environment        = var.environment
  private_cluster    = var.private_cluster
  enable_autoscaling = var.enable_autoscaling
  node_count         = var.node_count
  machine_type       = var.machine_type
  disk_size_gb       = var.disk_size_gb

  # If we have a custom VPC, use it
  network    = var.network
  subnetwork = var.subnetwork
}

