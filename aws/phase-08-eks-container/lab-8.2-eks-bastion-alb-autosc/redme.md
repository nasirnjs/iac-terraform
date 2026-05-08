# Lab 8.2 — EKS with Private Endpoint, SSM Bastion, ALB Controller & Cluster Autoscaler

Provision an Amazon EKS cluster with a **private API endpoint**, accessed via an **SSM-managed bastion host** in a private subnet. Includes the AWS Load Balancer Controller and Kubernetes Cluster Autoscaler.

## Architecture

- **VPC** — 3 AZs, public + private subnets, single NAT Gateway. Subnets tagged for ELB auto-discovery.
- **EKS** — managed control plane with **private-only API endpoint**. Managed node group on `t3a.medium` instances.
- **Bastion host** — Ubuntu 24.04 LTS, `t2.micro` (configurable via `bastion_instance_type`, `bastion_ami_id`), in a **public subnet** with a public IP. SSH (port 22) is restricted to `var.bastion_allowed_cidr`. SSM Session Manager remains available as a backup access path. User-data installs SSM agent, `aws-cli`, `kubectl`, `helm` and runs `aws eks update-kubeconfig` for the `ubuntu` user.
- **EKS access** — Bastion IAM role granted cluster-admin via EKS access entry; bastion SG allowed inbound 443 to the EKS cluster SG.
- **Add-ons** — `coredns`, `kube-proxy`, `vpc-cni`, `eks-pod-identity-agent`.
- **AWS Load Balancer Controller** — Helm-installed in `kube-system`, IRSA-bound.
- **Cluster Autoscaler** — Helm-installed in `kube-system`, IRSA-bound.

## File Layout

| File | Purpose |
|------|---------|
| `provider.tf` | Terraform + AWS / Kubernetes / Helm provider configuration |
| `variables.tf` | Input variable definitions |
| `terraform.tfvars` | Environment-specific values |
| `vpc.tf` | VPC module with EKS-required subnet tags |
| `bastion-host.tf` | Bastion EC2, IAM role/profile, SG, user-data |
| `main.tf` | EKS cluster, managed node group, access entry for bastion, SG ingress from bastion |
| `iam.tf` | IRSA roles for ALB controller and Cluster Autoscaler |
| `alb.tf` | Helm release: AWS Load Balancer Controller |
| `cluster-autoscaler.tf` | Helm release: Cluster Autoscaler |
| `outputs.tf` | Cluster + bastion outputs |

## Verify from the bastion

```bash
aws eks update-kubeconfig --region us-east-2 --name platform-eks
kubectl get nodes
kubectl -n kube-system get deploy aws-load-balancer-controller
kubectl -n kube-system get deploy cluster-autoscaler-aws-cluster-autoscaler
```
