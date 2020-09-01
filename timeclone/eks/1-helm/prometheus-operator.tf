resource "helm_release" "prometheus_operator" {
  name       = "prometheus-operator"
  namespace  = "monitoring"
  chart      = "prometheus-operator"
  repository = data.helm_repository.stable.metadata.0.name
  version    = "8.10.0"

  values = [
    "${file("values/prometheus-operator-values.yaml")}"
  ]

  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName"
    value = kubernetes_storage_class.prometheus_operator.metadata.0.name
  }

  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage"
    value = "60Gi"
  }

  set {
    name  = "grafana.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/security-groups"
    value = data.terraform_remote_state.dev_eks_ugen.outputs.central_elb_sg.id
  }

  set {
    name  = "grafana.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/certificate-arn"
    value = "arn:aws:acm:us-east-1:204995021158:certificate/80a6b40f-c0fe-4192-955b-d74477ed2137"
  }

  set {
    name  = "grafana.service.type"
    value = "NodePort"
  }

  depends_on = [
    helm_release.kubernetes_dashboard,
  ]
}


resource "kubernetes_storage_class" "prometheus_operator" {
  metadata {
    name = "prometheus-operator"
  }
  storage_provisioner = "kubernetes.io/aws-ebs"
  reclaim_policy      = "Retain"
  parameters = {
    type = "gp2"
  }
  allow_volume_expansion = true

  depends_on = [
    helm_release.kubernetes_dashboard,
  ]
}
