resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  namespace  = "kube-system"
  chart      = "metrics-server"
  repository = data.helm_repository.bitnami.metadata.0.name
  version    = "4.3.1"

  depends_on = [
    helm_release.sealed_secrets,
  ]
}
