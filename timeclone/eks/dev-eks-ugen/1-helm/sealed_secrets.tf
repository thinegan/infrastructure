# Run this when `sealed-secrets-key` is already restored from velero
resource "helm_release" "sealed_secrets" {
  name             = "sealed-secrets"
  namespace        = "kube-system"
  chart            = "sealed-secrets"
  repository       = data.helm_repository.stable.metadata.0.name
  version          = "1.8.0"
  disable_webhooks = true

}
