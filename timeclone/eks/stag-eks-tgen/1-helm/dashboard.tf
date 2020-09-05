resource "helm_release" "kubernetes_dashboard" {
  name       = "kubernetes-dashboard"
  namespace  = "kube-system"
  chart      = "kubernetes-dashboard"
  repository = data.helm_repository.stable.metadata.0.name
  version    = "1.10.1"

  values = [
    "${file("values/dashboard-values.yaml")}"
  ]

  set {
    name  = "service.type"
    value = "NodePort"
  }

  set {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/security-groups"
    value = data.terraform_remote_state.stag_eks_tgen.outputs.central_elb_sg.id
  }

  set {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/certificate-arn"
    value = "arn:aws:acm:us-east-1:204995021158:certificate/80a6b40f-c0fe-4192-955b-d74477ed2137"
  }

  depends_on = [
    helm_release.dns_external_staging,
    # helm_release.prometheus_operator,
  ]
}