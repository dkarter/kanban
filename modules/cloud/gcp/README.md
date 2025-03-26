# GCP Module for Kanban

This module orchestrates all Google Cloud Platform resources needed for the Kanban application.

## Components

- **Kubernetes (GKE)**: Managed Kubernetes cluster for running the Kanban application
- **Argo CD**: GitOps continuous delivery tool for Kubernetes (bootstrapped with Terraform)

## Usage

```hcl
module "gcp" {
  source = "./modules/cloud/gcp"

  # Required
  project_id = "your-gcp-project-id"
  
  # Optional with defaults
  region          = "us-central1"
  cluster_name    = "kanban-cluster"
  environment     = "prod"
  private_cluster = true
  machine_type    = "e2-small"
  
  # Argo CD configuration
  deploy_argocd        = true
  argocd_namespace     = "argocd"
  argocd_chart_version = "5.51.4"
  argocd_expose_ui     = false
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

## Argo CD GitOps Setup

After Terraform bootstraps Argo CD, it's designed to manage itself through GitOps:

1. Access Argo CD with:
   ```bash
   kubectl port-forward svc/argocd-server -n argocd 8080:443
   ```

2. Get the initial admin password:
   ```bash
   kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
   ```

3. Create an Argo CD Application manifest to manage Argo CD itself:
   ```yaml
   apiVersion: argoproj.io/v1alpha1
   kind: Application
   metadata:
     name: argocd
     namespace: argocd
   spec:
     project: default
     source:
       repoURL: https://argoproj.github.io/argo-helm
       targetRevision: 5.51.4
       chart: argo-cd
       # Add your values here
     destination:
       server: https://kubernetes.default.svc
       namespace: argocd
     syncPolicy:
       automated:
         prune: true
         selfHeal: true
   ```

4. Apply the Application manifest:
   ```bash
   kubectl apply -f argocd-application.yaml
   ```

After this setup, Argo CD will manage its own configuration through GitOps, rather than Terraform

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | The ID of the created GKE cluster |
| cluster_name | The name of the created GKE cluster |
| cluster_endpoint | The endpoint for the GKE cluster API server |
| cluster_ca_certificate | The public certificate authority of the cluster |
| region | The region of the GKE cluster |
| argocd_namespace | The namespace where Argo CD is deployed |
| argocd_admin_password_command | Command to retrieve the Argo CD admin password |
| argocd_port_forward_command | Command to port forward the Argo CD UI |