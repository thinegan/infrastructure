# resource "helm_release" "metrics_server" {
#   name       = "metrics-server"
#   namespace  = "kube-system"
#   chart      = "metrics-server"
#   repository = data.helm_repository.stable.metadata.0.name
#   version    = "2.11.0"

#   depends_on = [
#     helm_release.sealed_secrets,
#   ]
# }
