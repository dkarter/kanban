terraform {
  required_version = "~> 1.10"
  required_providers {
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

locals {
  argocd_namespace = var.namespace
}

# Create namespace for Argo CD
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = local.argocd_namespace
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  # Ignore changes to metadata to prevent conflicts with Argo CD self-management
  lifecycle {
    ignore_changes = [
      metadata[0].labels,
      metadata[0].annotations,
    ]
  }
}

# Deploy Argo CD using Helm chart (bootstrap only)
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  values = [
    var.values_file != "" ? file(var.values_file) : yamlencode({}),
    var.additional_values
  ]

  # Use set for any specific overrides
  set {
    name  = "server.service.type"
    value = var.expose_ui ? "LoadBalancer" : "ClusterIP"
  }

  # CRITICAL: Prevent Terraform from managing Argo CD after initial deployment
  # This enables Argo CD to self-manage through GitOps
  lifecycle {
    ignore_changes = all
  }

  depends_on = [
    kubernetes_namespace.argocd
  ]
}