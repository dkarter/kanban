# Kanban Infrastructure Modules

This directory contains infrastructure-as-code modules for deploying and managing the Kanban application.

## Available Modules

### Cloud Infrastructure

- [**GCP**](./cloud/gcp/): Google Cloud Platform resources including GKE Kubernetes cluster
  - Cost-optimized for limited GCP credits ($300)
  - Single production environment setup

### Integrations

- [**GitHub**](./integrations/github/): GitHub repository and project management

## Usage

To use these modules, create a terraform configuration file and reference the modules:

```hcl
module "gcp" {
  source = "./modules/cloud/gcp"
  
  project_id = "your-gcp-project-id"
  # Additional configuration as needed
}
```

## Getting Started

1. Copy the example terraform.tfvars file:
   ```
   cp modules/cloud/gcp/terraform.tfvars.example terraform.tfvars
   ```

2. Edit the terraform.tfvars file with your specific values

3. Initialize Terraform:
   ```
   terraform init
   ```

4. Plan and apply your changes:
   ```
   terraform plan
   terraform apply
   ```

## Security Best Practices

- Never commit actual credentials to version control
- Keep terraform.tfvars files in .gitignore
- Use environment variables or secure secret management for sensitive values