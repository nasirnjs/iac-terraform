# Lab 8.1 — EKS with AWS Load Balancer Controller & Cluster Autoscaler

Provision an Amazon EKS cluster on AWS using Terraform, with the AWS Load Balancer Controller (for ALB/NLB Ingress) and the Kubernetes Cluster Autoscaler installed via Helm.

## Architecture

- **VPC** — 3 AZs, public + private subnets, single NAT Gateway. Subnets tagged for ELB auto-discovery.
- **EKS** — managed control plane with public endpoint and a managed node group on `t3a.medium` instances.
- **Add-ons** — `coredns`, `kube-proxy`, `vpc-cni`, `eks-pod-identity-agent`.
- **AWS Load Balancer Controller** — Helm-installed in `kube-system`, IRSA-bound IAM role for provisioning ALBs/NLBs from Kubernetes Ingress/Service objects.
- **Cluster Autoscaler** — Helm-installed in `kube-system`, IRSA-bound IAM role to scale the EKS managed node group between `min_size` and `max_size`.

## File Layout

| File | Purpose |
|------|---------|
| `provider.tf` | Terraform + AWS / Kubernetes / Helm provider configuration |
| `variables.tf` | Input variable definitions |
| `terraform.tfvars` | Environment-specific values |
| `vpc.tf` | VPC module with EKS-required subnet tags |
| `main.tf` | EKS cluster + managed node group |
| `iam.tf` | IRSA roles for ALB controller and Cluster Autoscaler |
| `alb.tf` | Helm release: AWS Load Balancer Controller |
| `cluster-autoscaler.tf` | Helm release: Cluster Autoscaler |
| `outputs.tf` | Cluster endpoint, VPC, subnet outputs |



## Update EKS Kubeconfig & Verify Controllers

```bash
aws eks update-kubeconfig --region us-east-2 --name platform-eks
```

Verify controllers:

```bash
kubectl -n kube-system get deploy aws-load-balancer-controller
kubectl -n kube-system get deploy cluster-autoscaler-aws-cluster-autoscaler
kubectl get nodes
```

