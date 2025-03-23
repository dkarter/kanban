# GCP Module for Kanban

This module orchestrates all Google Cloud Platform resources needed for the Kanban application.

## Components

- **Kubernetes (GKE)**: Managed Kubernetes cluster for running the Kanban application

## Usage

```hcl
module "gcp" {
  source = "./modules/cloud/gcp"

  # Required
  project_id = "your-gcp-project-id"
  
  # Optional with defaults
  region          = "us-central1"
  cluster_name    = "kanban-cluster"
  environment     = "dev"
  private_cluster = true
  machine_type    = "e2-standard-2"
}
```

## Configuration

Create a `terraform.tfvars` file in your root directory to set the required variables:

```hcl
project_id = "your-gcp-project-id"
region     = "us-central1"
```

## Prerequisites

Before applying this Terraform configuration:

1. Create a GCP project
2. Enable required APIs:
   ```bash
   gcloud services enable container.googleapis.com \
       compute.googleapis.com \
       iam.googleapis.com
   ```
3. Ensure you have proper authentication set up for Terraform to access GCP

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | The ID of the created GKE cluster |
| cluster_name | The name of the created GKE cluster |
| cluster_endpoint | The endpoint for the GKE cluster API server |
| cluster_ca_certificate | The public certificate authority of the cluster |
| region | The region of the GKE cluster |