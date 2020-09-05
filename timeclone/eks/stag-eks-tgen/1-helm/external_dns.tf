resource "helm_release" "dns_external_staging" {
  name       = "dns-external-staging"
  namespace  = "kube-system"
  chart      = "external-dns"
  repository = data.helm_repository.stable.metadata.0.name
  version    = "2.19.1"

  values = [
    "${file("values/external-dns-value.yaml")}"
  ]

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "rbac.serviceAccountAnnotations.eks\\.amazonaws\\.com/role-arn"
    value = data.terraform_remote_state.stag_eks_tgen.outputs.oidc_external_dns_role.arn
  }

  depends_on = [
    helm_release.alb_ingress_controller,
  ]
}