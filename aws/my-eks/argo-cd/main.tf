
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "argo-cd" {
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
      alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:us-east-2:654654369278:certificate/cfc29844-8499-42fc-bad6-30c0e0b1142e
      alb.ingress.kubernetes.io/vpc-id: vpc-0e320fff5fe6d127b
      alb.ingress.kubernetes.io/subnets: subnet-0a22ad3b119374a25, subnet-0606050b8e773bfe4
      alb.ingress.kubernetes.io/security-groups: sg-0a7fccf1e195c8001
  hosts:
    - argocd.buddyapi.neutrixsystems.com
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