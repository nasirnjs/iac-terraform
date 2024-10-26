resource "helm_release" "prometheus" {
  provider = helm
  name     = "prometheus"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"

  namespace        = "monitoring"
  cleanup_on_fail  = false
  create_namespace = true

  values = [
    <<-EOT
alertmanager:
  enabled: true

server:
  persistentVolume:
    size: 50Gi
    storageClass: gp2
EOT
  ]

}