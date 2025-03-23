locals {
  project_id   = var.project_id
  cluster_name = var.cluster_name
  region       = var.region
  network      = var.network
  subnetwork   = var.subnetwork
}

terraform {
  required_version = "~> 1.10"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.9.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.9.0"
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

# GKE cluster
resource "google_container_cluster" "primary" {
  name     = local.cluster_name
  location = local.region
  
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = local.network
  subnetwork = local.subnetwork

  # Enable Workload Identity
  workload_identity_config {
    workload_pool = "${local.project_id}.svc.id.goog"
  }

  # Enable network policy (Calico)
  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  # Enable IP allocation policy for VPC-native cluster
  ip_allocation_policy {
    # Use default auto-allocation
  }

  # Enable private cluster
  private_cluster_config {
    enable_private_nodes    = var.private_cluster
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.private_cluster ? "172.16.0.0/28" : null
  }

  # Stability and security settings
  release_channel {
    channel = "REGULAR"
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"  # 3 AM
    }
  }
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${local.cluster_name}-node-pool"
  location   = local.region
  cluster    = google_container_cluster.primary.name
  node_count = var.node_count

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]

    labels = {
      env = var.environment
    }

    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb
    disk_type    = "pd-standard"
    
    # Use Container-Optimized OS
    image_type = "COS_CONTAINERD"

    # Enable Workload Identity on the nodes
    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    # Enable secure boot for increased security
    shielded_instance_config {
      enable_secure_boot = true
    }
  }

  # Enable auto-scaling
  dynamic "autoscaling" {
    for_each = var.enable_autoscaling ? [1] : []
    content {
      min_node_count = var.min_node_count
      max_node_count = var.max_node_count
    }
  }

  # Enable auto-upgrade and auto-repair
  management {
    auto_repair  = true
    auto_upgrade = true
  }
}