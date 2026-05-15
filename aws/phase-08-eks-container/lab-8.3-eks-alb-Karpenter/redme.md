# Lab 8.3 — EKS with AWS Load Balancer Controller & Karpenter

Provision an Amazon EKS cluster on AWS using Terraform, with the AWS Load Balancer Controller (for ALB/NLB Ingress) and **Karpenter** for fast, flexible, just-in-time node provisioning. A small managed node group is retained to host Karpenter itself and other system controllers.

## Architecture

- **VPC** — 3 AZs, public + private subnets, single NAT Gateway. Subnets tagged for ELB auto-discovery and Karpenter subnet discovery (`karpenter.sh/discovery`).
- **EKS** — managed control plane with public endpoint and a small managed node group on `t3a.medium` (system workloads + Karpenter controller).
- **Add-ons** — `coredns`, `kube-proxy`, `vpc-cni`, `eks-pod-identity-agent`.
- **AWS Load Balancer Controller** — Helm-installed in `kube-system`, IRSA-bound IAM role for provisioning ALBs/NLBs from Kubernetes Ingress/Service objects.
- **Karpenter** — Helm-installed in `kube-system` (or `karpenter` namespace). Watches unschedulable pods and provisions right-sized EC2 instances directly (no node group). Uses an SQS interruption queue + EventBridge rules to handle spot interruptions and instance termination gracefully.

---

## Planned Changes — Adding Karpenter

This section tracks what is being added on top of the lab-8.2 baseline to introduce Karpenter.

### Decisions (defaults)

| Topic | Decision |
|---|---|
| Coexistence with Cluster Autoscaler | **Remove** Cluster Autoscaler — Karpenter supersedes it |
| Auth model | **EKS Pod Identity** (modern, already enabled via the `eks-pod-identity-agent` addon) |
| NodePool / EC2NodeClass | Provisioned via Terraform using `kubectl_manifest` |
| Capacity strategy | Mixed **on-demand + spot**, instance families: `t3a`, `m5`, `c6i` |

### New files

| File | Purpose |
|---|---|
| `karpenter.tf` | Karpenter Helm release + `EC2NodeClass` and `NodePool` manifests |
| `karpenter-iam.tf` *(or extend `iam.tf`)* | Karpenter controller role + Karpenter node IAM role + instance profile |

### New resources / modules

- **`module "karpenter"`** — `terraform-aws-modules/eks/aws//modules/karpenter`. Creates controller IAM role, node IAM role, SQS interruption queue, and EventBridge rules in one shot.
- **`helm_release "karpenter"`** — chart from `oci://public.ecr.aws/karpenter/karpenter`.
- **`kubectl_manifest`** for:
  - `EC2NodeClass` — AMI family, subnet/SG discovery tags, node IAM role
  - `NodePool` — instance requirements, limits, disruption policy
- **EKS access entry** — for the Karpenter node role so Karpenter-provisioned nodes can join the cluster (required with the EKS access entries API).

### Changes to existing files

| File | Change |
|---|---|
| `main.tf` | Add `node_security_group_tags = { "karpenter.sh/discovery" = var.cluster_name }` on the EKS module |
| `vpc.tf` | Add `"karpenter.sh/discovery" = var.cluster_name` to `private_subnet_tags` for subnet auto-discovery |
| `provider.tf` | Add `kubectl` provider (`gavinbunney/kubectl`, `~> 1.14`) for applying NodePool/EC2NodeClass |
| `variables.tf` | Add `karpenter_chart_version`, `karpenter_instance_categories`, `karpenter_capacity_types`, `karpenter_namespace` |
| `terraform.tfvars` | Provide values for the new variables |
| `outputs.tf` | Output `karpenter_queue_name`, `karpenter_node_iam_role_arn` |
| `cluster-autoscaler.tf` | **Remove** — replaced by Karpenter |
| `iam.tf` | Remove `cluster_autoscaler_irsa` module block |

### Required providers (added)

```hcl
kubectl = {
  source  = "gavinbunney/kubectl"
  version = "~> 1.14"
}
```

---

## File Layout (target)

| File | Purpose |
|------|---------|
| `provider.tf` | Terraform + AWS / Kubernetes / Helm / kubectl provider configuration |
| `variables.tf` | Input variable definitions |
| `terraform.tfvars` | Environment-specific values |
| `vpc.tf` | VPC module with EKS + Karpenter subnet tags |
| `main.tf` | EKS cluster + small managed node group (for system pods + Karpenter controller) |
| `iam.tf` | IRSA role for ALB controller |
| `karpenter-iam.tf` | Karpenter controller + node IAM roles, SQS, EventBridge |
| `alb.tf` | Helm release: AWS Load Balancer Controller |
| `karpenter.tf` | Helm release: Karpenter + `EC2NodeClass` + `NodePool` manifests |
| `outputs.tf` | Cluster endpoint, VPC, subnet, Karpenter queue + node role outputs |

---

## Update EKS Kubeconfig & Verify Controllers

```bash
aws eks update-kubeconfig --region us-east-2 --name platform-eks
```

Verify controllers:

```bash
kubectl -n kube-system get deploy aws-load-balancer-controller
kubectl -n kube-system get deploy karpenter
kubectl get nodepool,ec2nodeclass
kubectl get nodes -L karpenter.sh/nodepool,node.kubernetes.io/instance-type,karpenter.sh/capacity-type
```

Test Karpenter scale-up by deploying a workload that exceeds current node capacity:

```bash
kubectl create deployment inflate --image=public.ecr.aws/eks-distro/kubernetes/pause:3.7
kubectl scale deployment inflate --replicas=20
kubectl get nodes -w
```
