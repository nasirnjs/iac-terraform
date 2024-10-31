resource "helm_release" "argo-cd" {
  depends_on       = [helm_release.aws-load-balancer-controller]
  name             = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argo"
  version          = "5.51.6"
  create_namespace = true
  values = [
    <<-EOT

server: 
  ingress:
    enabled: true
    annotations:
      kubernetes.io/ingress.class : alb
      alb.ingress.kubernetes.io/backend-protocol: HTTPS
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTPS":443}]'
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/target-type: ip
      alb.ingress.kubernetes.io/certificate-arn: ${local.medlify-acm-arn}
      alb.ingress.kubernetes.io/subnets: ${module.vpc.public_subnet_ids[0]}, ${module.vpc.public_subnet_ids[1]}, ${module.vpc.public_subnet_ids[2]}
      alb.ingress.kubernetes.io/security-groups: ${module.eks.public_alb_sg}
  hosts:
    - argocd.timam.io
  ingressGrpc:
    enabled: true
    isAWSALB: true
    awsALB:
      serviceType: NodePort

  redis-ha:
    enabled: true

  controller:
    replicas: 1

  server:
    autoscaling:
      enabled: true
      minReplicas: 2

  repoServer:
    autoscaling:
      enabled: true
      minReplicas: 2

  applicationSet:
    replicas: 2

EOT
  ]
}
