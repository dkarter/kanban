- [ ] set up argo via simple helm

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

- [ ] delete the terraform for argocd
- [ ] add task for installing argocd under k8s namespace
- [ ] check the values file (might need to extract it from the terraform config)
