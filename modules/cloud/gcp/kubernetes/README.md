# GCP Kubernetes (GKE) Module

This module creates a standard Google Kubernetes Engine (GKE) cluster for the Kanban application.

## Features

- Regional GKE cluster for high availability
- Separately managed node pool with autoscaling
- Workload Identity enabled for secure GCP service access
- Private cluster option for enhanced security
- Network policy enabled (Calico)
- Regular release channel for stable updates
- Maintenance window configured for minimal disruption

## Usage

```hcl
module "gke_cluster" {
  source = "./modules/cloud/gcp/kubernetes"

  project_id   = "your-gcp-project-id"
  cluster_name = "kanban-cluster"
  region       = "us-central1"
  
  # Optional parameters (defaults shown)
  # network            = "default"
  # subnetwork         = "default"
  # private_cluster    = true
  # node_count         = 2
  # machine_type       = "e2-standard-2"
  # disk_size_gb       = 100
  # environment        = "production"
  # enable_autoscaling = true
  # min_node_count     = 1
  # max_node_count     = 5
}
```

## Requirements

- Terraform >= 1.0
- Google Cloud project with the following APIs enabled:
  - Kubernetes Engine API
  - Compute Engine API
  - Container Registry API
  - IAM API

## Accessing the Cluster

After the cluster is created, you can configure kubectl to access it:

```bash
gcloud container clusters get-credentials kanban-cluster --region us-central1 --project your-gcp-project-id
```

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | The ID of the created GKE cluster |
| cluster_name | The name of the created GKE cluster |
| cluster_endpoint | The endpoint for the GKE cluster API server |
| cluster_ca_certificate | The public certificate authority of the cluster |
| node_pool_id | The ID of the created node pool |
| region | The region of the GKE cluster |