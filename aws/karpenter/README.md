# EKS Cluster with Karpenter

Karpenter transforms Kubernetes autoscaling by replacing fixed node pools with on-demand, pod-driven EC2 provisioning. It reacts in seconds to unschedulable pods, selects the most cost-effective instance types across your specified AZs, and continuously right-sizes your fleet through optional consolidation.
In short, Karpenter lets your cluster scale with precision and speed so you spend less time managing infrastructure and more time shipping value.


Cluster Autoscaler vs Karpenter	Architecture, Scaling Behavior & Components


| Aspect             | Cluster Autoscaler                                                       | Karpenter                                                            |
|--------------------|---------------------------------------------------------------------------|----------------------------------------------------------------------|
| **Controller**     | Runs as a Deployment in your cluster (`kube-system`)                      | Runs as a Deployment in your cluster (`karpenter` namespace)         |
| **Node Discovery** | Watches Auto Scaling Groups (ASGs) / Managed NodeGroups                   | Watches Provisioner CRs and directly calls EC2 APIs                  |
| **Provisioning**   | Scales existing node groups; can only increase/decrease replica counts    | Creates, labels, and configures EC2 instances on-the-fly based on Pod needs |
| **Resource Model** | Considers pending Pods when node group usage > threshold                  | Uses Provisioner CRD to encode constraints (instance types, zones, taints) |
| **Metrics Source** | Kubernetes API + ASG state                                                | Kubernetes API + Cloud API (EC2 capacity offers)                    |
| **Trigger**        | Pending Pods + underutilized nodes                                        | Pending Pods                                                         |
| **Scale-up Delay** | Typically 1–2 minutes (sync loop + ASG cooldowns)                         | Seconds to a minute (provisioner watches & immediate EC2 calls)      |
| **Scale-down Logic** | Evicts underutilized nodes after TTL (default 10m)                      | Consolidation optional: will terminate underutilized instances       |
| **Bin-packing**    | No real bin-packing – spreads across ASGs                                  | Yes: tries to pack pods onto fewer, smaller instances                |

**Before you write any Terraform to stand up EKS + Karpenter, make sure your local workstation has the following in place**

- Terraform CLI
- AWS CLI v2
- Installed and configured via aws configure
- kubectl

**Steps 1: Configure Terrafrom Provider provider.tf file**

```bash
module "eks_example_karpenter" {
  source  = "terraform-aws-modules/eks/aws//examples/karpenter"
  version = "20.36.0"
}

data "aws_availability_zones" "azs" {}
```

**Steps 2: Configure variable variables.tf file**

```bash
variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "private_subnets" {
  description = "Subnets CIDR"
  type        = list(string)
}

variable "public_subnets" {
  description = "Subnets CIDR"
  type        = list(string)
}

variable "cluster_name" {
  type        = string
}

variable "region" {
  type        = string
}
```

**Steps 3: Configure terrafrom.tfvars file**

```bash
vpc_cidr        = "192.168.0.0/16"
private_subnets = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
public_subnets  = ["192.168.4.0/24", "192.168.5.0/24", "192.168.6.0/24"]
cluster_name    = "karpenter"
region = "us-east-2"
```


**Steps 4: create a main.tf file, you can make modify or update as per your need, This Terraform configuration performs the following tasks**

- Create VPC and subnets.
- Deploy EKS cluster with private subnets.
- Set up node group specifically for Karpenter.
- Configure IAM roles/policies for Karpenter to operate.
- Deploy Karpenter via Helm from ECR public.

```bash
# 1. Providers, Defines two AWS providers
# One for the default region (var.region)
# One named virginia for interacting with AWS Public ECR, which is hosted in us-east-1.
provider "aws" {
  region = var.region
}
provider "aws" {
  region = "us-east-1"
  alias  = "virginia"
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
  }
}


data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.virginia
}

locals {
  name   = var.cluster_name
  region = var.region

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-eks"
    GithubOrg  = "terraform-aws-modules"
  }
}

################################################################################
# VPC
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.azs.names
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    "karpenter.sh/discovery"         = local.name
  }

  tags = local.tags
}

################################################################################
# EKS Cluster
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.31"
  subnet_ids      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access           = true

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  eks_managed_node_groups = {
    karpenter = {
      ami_type       = "BOTTLEROCKET_x86_64"
      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 3
      desired_size = 1

      labels = {
        "karpenter.sh/controller" = "true"
      }

      tags = {
        "Name" = "karpenter"
      }
    }
  }

  control_plane_subnet_ids = module.vpc.intra_subnets

  node_security_group_tags = merge(local.tags, {
    "karpenter.sh/discovery" = local.name
  })

  tags = local.tags
}

################################################################################
# Karpenter Module
################################################################################

module "karpenter" {
  source = "terraform-aws-modules/eks/aws//modules/karpenter"

  cluster_name                    = module.eks.cluster_name
  enable_v1_permissions           = true
  create                          = true
  node_iam_role_use_name_prefix   = false
  node_iam_role_name              = local.name
  create_pod_identity_association = true

  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = local.tags
}

################################################################################
# Karpenter Helm Release
################################################################################

resource "helm_release" "karpenter" {
  provider            = helm
  namespace           = "kube-system"
  name                = "karpenter"
  repository          = "oci://public.ecr.aws/karpenter"
  repository_username = data.aws_ecrpublic_authorization_token.token.user_name
  repository_password = data.aws_ecrpublic_authorization_token.token.password
  chart               = "karpenter"
  version             = "1.1.1"
  wait                = false

  values = [
    <<-EOT
    nodeSelector:
      karpenter.sh/controller: 'true'
    dnsPolicy: Default
    settings:
      clusterName: ${module.eks.cluster_name}
      clusterEndpoint: ${module.eks.cluster_endpoint}
      interruptionQueue: ${module.karpenter.queue_name}
    webhook:
      enabled: false
    EOT
  ]
}

```

**Steps 5: Apply karpenter karpenter.tf file**

```bash
---
apiVersion: karpenter.k8s.aws/v1
kind: EC2NodeClass
metadata:
  name: default
spec:
  amiSelectorTerms:
    - alias: bottlerocket@latest
  role: karpenter
  subnetSelectorTerms:
    - tags:
        karpenter.sh/discovery: karpenter
  securityGroupSelectorTerms:
    - tags:
        karpenter.sh/discovery: karpenter
  tags:
    karpenter.sh/discovery: karpenter
---
apiVersion: karpenter.sh/v1
kind: NodePool
metadata:
  name: default
spec:
  template:
    spec:
      requirements:
        - key: kubernetes.io/arch
          operator: In
          values: ["amd64"]
        - key: kubernetes.io/os
          operator: In
          values: ["linux"]
        - key: karpenter.sh/capacity-type
          operator: In
          values: ["spot"]
        - key: karpenter.k8s.aws/instance-category
          operator: In
          values: ["c", "m", "r", "t"]
        - key: karpenter.k8s.aws/instance-generation
          operator: Gt
          values: ["2"]
      nodeClassRef:
        group: karpenter.k8s.aws
        kind: EC2NodeClass
        name: default
      expireAfter: 720h # 30 * 24h = 720h
  limits:
    cpu: 1000
  disruption:
    consolidationPolicy: WhenEmptyOrUnderutilized
    consolidateAfter: 1m
```


**Steps 6: Apply a test Deployment**

```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: inflate
spec:
  replicas: 5
  selector:
    matchLabels:
      app: inflate
  template:
    metadata:
      labels:
        app: inflate
    spec:
      terminationGracePeriodSeconds: 0
      containers:
        - name: inflate
          image: nginx
```

To provision the provided configurations you need to execute:
```
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```
Once the cluster is up and running, you can check that Karpenter is functioning as intended with the following command:

```
# First, make sure you have updated your local kubeconfig
aws eks --region eu-west-1 update-kubeconfig --name ex-karpenter

# Second, deploy the Karpenter NodeClass/NodePool
kubectl apply -f karpenter.yaml

# Second, deploy the example deployment
kubectl apply -f inflate.yaml

# You can watch Karpenter's controller logs with
kubectl logs -f -n kube-system -l app.kubernetes.io/name=karpenter -c controller
```

[References 1](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)

[References 2](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest/examples/karpenter)

[References 3](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/v20.36.0/examples/karpenter/main.tf)

[References 4](https://dev.to/aws-builders/migrating-from-eks-cluster-autoscaler-to-karpenter-3h17)