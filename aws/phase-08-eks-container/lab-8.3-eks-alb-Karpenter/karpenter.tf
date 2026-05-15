# Karpenter controller (Helm) + default EC2NodeClass + default NodePool

resource "helm_release" "karpenter" {
  name             = "karpenter"
  namespace        = var.karpenter_namespace
  create_namespace = var.karpenter_namespace != "kube-system"

  repository = "oci://public.ecr.aws/karpenter"
  chart      = "karpenter"
  version    = var.karpenter_chart_version
  wait       = false

  values = [
    yamlencode({
      serviceAccount = {
        name = "karpenter"
      }
      settings = {
        clusterName       = module.eks.cluster_name
        clusterEndpoint   = module.eks.cluster_endpoint
        interruptionQueue = module.karpenter.queue_name
      }
    })
  ]

  depends_on = [module.eks, module.karpenter]
}

# Default EC2NodeClass — tells Karpenter HOW to build a node (AMI, subnets, SGs, role).
resource "kubectl_manifest" "karpenter_node_class" {
  yaml_body = yamlencode({
    apiVersion = "karpenter.k8s.aws/v1"
    kind       = "EC2NodeClass"
    metadata = {
      name = "general-al2023"
    }
    spec = {
      amiFamily = var.karpenter_ami_family
      amiSelectorTerms = [
        {
          alias = var.karpenter_ami_alias
        }
      ]
      role = module.karpenter.node_iam_role_name
      subnetSelectorTerms = [
        {
          tags = {
            "karpenter.sh/discovery" = var.cluster_name
          }
        }
      ]
      securityGroupSelectorTerms = [
        {
          tags = {
            "karpenter.sh/discovery" = var.cluster_name
          }
        }
      ]
      tags = {
        Environment              = var.environment
        Project                  = var.project_name
        "karpenter.sh/discovery" = var.cluster_name
      }
    }
  })

  depends_on = [helm_release.karpenter]
}

# Spot NodePool — weight 100, preferred. Karpenter tries this pool first.
resource "kubectl_manifest" "karpenter_node_pool_spot" {
  yaml_body = yamlencode({
    apiVersion = "karpenter.sh/v1"
    kind       = "NodePool"
    metadata = {
      name = "spot-pool"
    }
    spec = {
      weight = 100
      template = {
        spec = {
          nodeClassRef = {
            group = "karpenter.k8s.aws"
            kind  = "EC2NodeClass"
            name  = "general-al2023"
          }
          requirements = [
            {
              key      = "karpenter.k8s.aws/instance-family"
              operator = "In"
              values   = var.karpenter_instance_families
            },
            {
              key      = "karpenter.sh/capacity-type"
              operator = "In"
              values   = ["spot"]
            },
            {
              key      = "kubernetes.io/arch"
              operator = "In"
              values   = var.karpenter_arch
            },
            {
              key      = "kubernetes.io/os"
              operator = "In"
              values   = ["linux"]
            }
          ]
          expireAfter = "720h"
        }
      }
      limits = {
        cpu    = "100"
        memory = "300Gi"
      }
      disruption = {
        consolidationPolicy = "WhenEmptyOrUnderutilized"
        consolidateAfter    = "1m"
        budgets = [
          {
            nodes = var.karpenter_disruption_budget_nodes
          }
        ]
      }
    }
  })

  depends_on = [kubectl_manifest.karpenter_node_class]
}

# On-Demand NodePool — weight 10, fallback when spot capacity is unavailable
# or when pods explicitly request capacity-type=on-demand.
resource "kubectl_manifest" "karpenter_node_pool_on_demand" {
  yaml_body = yamlencode({
    apiVersion = "karpenter.sh/v1"
    kind       = "NodePool"
    metadata = {
      name = "on-demand-pool"
    }
    spec = {
      weight = 10
      template = {
        spec = {
          nodeClassRef = {
            group = "karpenter.k8s.aws"
            kind  = "EC2NodeClass"
            name  = "general-al2023"
          }
          requirements = [
            {
              key      = "karpenter.k8s.aws/instance-family"
              operator = "In"
              values   = var.karpenter_instance_families
            },
            {
              key      = "karpenter.sh/capacity-type"
              operator = "In"
              values   = ["on-demand"]
            },
            {
              key      = "kubernetes.io/arch"
              operator = "In"
              values   = var.karpenter_arch
            },
            {
              key      = "kubernetes.io/os"
              operator = "In"
              values   = ["linux"]
            }
          ]
          expireAfter = "720h"
        }
      }
      limits = {
        cpu    = "100"
        memory = "300Gi"
      }
      disruption = {
        consolidationPolicy = "WhenEmptyOrUnderutilized"
        consolidateAfter    = "1m"
        budgets = [
          {
            nodes = var.karpenter_disruption_budget_nodes
          }
        ]
      }
    }
  })

  depends_on = [kubectl_manifest.karpenter_node_class]
}
