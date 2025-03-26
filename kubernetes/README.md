# Kubernetes Resources for Kanban

This directory contains Kubernetes manifests and Argo CD application definitions for the Kanban project.

## Directory Structure

- **apps/**: Argo CD Application manifests
  - `argocd.yaml`: Self-management configuration for Argo CD

## GitOps Workflow

The Kanban project uses Argo CD for GitOps-based deployments:

1. **Terraform**: Provisions the GKE cluster and bootstraps Argo CD
2. **Argo CD**: Manages all Kubernetes resources, including itself
3. **Git**: All changes to application configuration flow through Git

## Setting Up Argo CD Self-Management

After Terraform has deployed the GKE cluster and bootstrapped Argo CD:

1. Apply the Argo CD self-management application:
   ```bash
   kubectl apply -f kubernetes/apps/argocd.yaml
   ```

2. Verify the application is synced:
   ```bash
   kubectl get applications -n argocd
   ```

## Adding New Applications

1. Create new Application manifests in the `apps/` directory
2. Commit and push to Git
3. Apply to the cluster:
   ```bash
   kubectl apply -f kubernetes/apps/your-new-app.yaml
   ```

4. Argo CD will automatically sync and deploy the application