# resource "helm_release" "cluster_autoscaler" {
#   name       = "cluster-autoscaler"
#   namespace  = "kube-system"
#   chart      = "cluster-autoscaler"
#   version    = "7.2.0"
#   repository = data.helm_repository.stable.metadata.0.name

#   set {
#     name  = "autoDiscovery.clusterName"
#     value = data.terraform_remote_state.dev_eks_ugen.outputs.dev_eks_ugen.cluster_id
#   }

#   set {
#     name  = "rbac.create"
#     value = "true"
#   }

#   set {
#     name  = "rbac.serviceAccountAnnotations.eks\\.amazonaws\\.com/role-arn"
#     value = data.terraform_remote_state.dev_eks_ugen.outputs.oidc_autoscaler_role.arn
#   }

#   depends_on = [
#     helm_release.metrics_server,
#   ]
# }