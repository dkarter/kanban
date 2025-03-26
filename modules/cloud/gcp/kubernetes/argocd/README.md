# Argo CD Bootstrap Module

This Terraform module performs the initial bootstrap of Argo CD onto a Kubernetes cluster. It's designed to handle only the initial deployment, after which Argo CD will manage itself via GitOps.

## Features

- One-time bootstrap deployment of Argo CD
- Prevents Terraform from overriding Argo CD updates (using `lifecycle { ignore_changes = all }`)
- Configurable via Helm values
- Cost-efficient resource defaults
- Security-conscious configuration

## Usage

```hcl
module "argocd" {
  source = "./modules/cloud/gcp/kubernetes/argocd"

  # Optional - defaults shown
  namespace     = "argocd"
  chart_version = "5.51.4"
  expose_ui     = false  # Set to true to expose UI with LoadBalancer
  
  # Optional - provide your own values.yaml file
  # values_file = "${path.module}/my-values.yaml"
  
  # Additional values in YAML format (will be merged with values_file)
  # additional_values = <<-EOT
  #   server:
  #     extraArgs:
  #       - --insecure
  # EOT
}
```

## Accessing Argo CD

After deploying Argo CD, you can access it using port forwarding:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Then access the UI at: https://localhost:8080

To get the initial admin password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

## GitOps Self-Management

To set up Argo CD to manage itself:

1. Create an `Application` manifest in your Git repository:

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
    targetRevision: 5.51.4  # Same version as initial deployment
    chart: argo-cd
    helm:
      values: |
        # Your values here - copy from values.yaml
  destination:
    server: https://kubernetes.default.svc
    namespace: argocd
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

2. Apply this with:

```bash
kubectl apply -f argocd-application.yaml
```

After this, any changes to the Argo CD configuration should be made through Git rather than Terraform.