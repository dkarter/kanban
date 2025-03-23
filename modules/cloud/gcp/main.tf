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
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.26.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12.0"
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

# Configure Kubernetes provider to connect to our cluster
data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.kanban_k8s_cluster.cluster_endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.kanban_k8s_cluster.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = "https://${module.kanban_k8s_cluster.cluster_endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.kanban_k8s_cluster.cluster_ca_certificate)
  }
}

# Deploy Argo CD (bootstrap only - Argo CD will manage itself after initial deployment)
module "argocd" {
  count  = var.deploy_argocd ? 1 : 0
  source = "./kubernetes/argocd"

  # Use the values defined in variables
  namespace     = var.argocd_namespace
  chart_version = var.argocd_chart_version
  expose_ui     = var.argocd_expose_ui
  
  # Optional additional values
  additional_values = var.argocd_additional_values

  depends_on = [
    module.kanban_k8s_cluster
  ]
}

