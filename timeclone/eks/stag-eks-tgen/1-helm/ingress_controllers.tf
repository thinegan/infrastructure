resource "helm_release" "alb_ingress_controller" {
  name       = "alb-ingress-controller"
  namespace  = "kube-system"
  chart      = "aws-alb-ingress-controller"
  repository = data.helm_repository.incubator.metadata.0.name
  version    = "0.1.14"

  set {
    name  = "awsRegion"
    value = "us-east-1"
  }

  set {
    name  = "awsVpcID"
    value = data.terraform_remote_state.devVPC.outputs.vpc_id
  }

  set {
    name  = "clusterName"
    value = data.terraform_remote_state.stag_eks_tgen.outputs.stag_eks_tgen.cluster_id
  }

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "rbac.serviceAccountAnnotations.eks\\.amazonaws\\.com/role-arn"
    value = data.terraform_remote_state.stag_eks_tgen.outputs.oidc_alb_ingress_controller_role.arn
  }

  depends_on = [
    helm_release.cluster_autoscaler,
  ]

}