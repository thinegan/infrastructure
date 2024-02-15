#########################################################################################################
# Helm -  metrics server
# https://artifacthub.io/packages/helm/metrics-server/metrics-server
#########################################################################################################
resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  namespace  = "kube-system"
  chart      = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server"
  version    = "3.11.0"

  set {
    name  = "apiService.create"
    value = "true"
  }

  set {
    name  = "apiService.insecureSkipTLSVerify"
    value = "true"
  }

  depends_on = [
    aws_iam_role.iam_role_oidc_external_dns,
  ]
}

#########################################################################################################
# Helm -  cluster-autoscaler
# https://artifacthub.io/packages/helm/cluster-autoscaler/cluster-autoscaler
#########################################################################################################
resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  namespace  = "kube-system"
  chart      = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  version    = "9.29.3"

  values = [
    file("${path.module}/values/autoscaler-values.yaml")
  ]

  set {
    name  = "autoDiscovery.clusterName"
    value = module.this.cluster_name
  }

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.iam_role_oidc_autoscaler.arn
  }

  depends_on = [
    aws_iam_role.iam_role_oidc_autoscaler,
    helm_release.metrics_server,
  ]
}

#########################################################################################################
# Helm -  aws-load-balancer-controller
# https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller
#########################################################################################################
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  version    = "1.6.1"

  set {
    name  = "awsRegion"
    value = "us-east-1"
  }

  set {
    name  = "awsVpcID"
    value = var.vpcid
  }

  set {
    name  = "clusterName"
    value = module.this.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.iam_role_oidc_load_balancer_controller.arn
  }

  depends_on = [
    aws_iam_role.iam_role_oidc_load_balancer_controller,
    helm_release.cluster_autoscaler,
  ]
}

#########################################################################################################
# Retrieve API token key and ZoneID from AWS Secret Manager
# Cloudflare API Access
#########################################################################################################
# Get Secret
data "aws_secretsmanager_secret_version" "get_cloudflare" {
  secret_id = var.secretmanagerid["cloudflare"]
}

provider "cloudflare" {
  api_token = jsondecode(data.aws_secretsmanager_secret_version.get_cloudflare.secret_string)["CLOUDFLARE_API_TOKEN"]
}

locals {
  zone_id = jsondecode(data.aws_secretsmanager_secret_version.get_cloudflare.secret_string)["CLOUDFLARE_ZONEID"]
  domain  = jsondecode(data.aws_secretsmanager_secret_version.get_cloudflare.secret_string)["CLOUDFLARE_DOMAIN"]
  email   = jsondecode(data.aws_secretsmanager_secret_version.get_cloudflare.secret_string)["CLOUDFLARE_EMAIL"]
}

#########################################################################################################
# Helm -  external-dns
# ref: https://artifacthub.io/packages/helm/bitnami/external-dns
#########################################################################################################
resource "helm_release" "dns_external" {
  name       = "external-dns"
  namespace  = "kube-system"
  chart      = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  version    = "6.25.1"

  set {
    name  = "provider"
    value = "cloudflare"
  }

  set {
    name  = "cloudflare.apiToken"
    value = jsondecode(data.aws_secretsmanager_secret_version.get_cloudflare.secret_string)["CLOUDFLARE_API_TOKEN"]
  }

  set {
    name  = "cloudflare.proxied"
    value = false
  }

  set {
    name  = "txtOwnerId"
    value = module.this.cluster_name
  }

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.iam_role_oidc_external_dns.arn
  }

  depends_on = [
    aws_iam_role.iam_role_oidc_external_dns,
    helm_release.aws_load_balancer_controller,
  ]
}

#########################################################################################################
# Helm -  kubernetes-dashboard
# ref: https://artifacthub.io/packages/helm/k8s-dashboard/kubernetes-dashboard
#########################################################################################################
resource "helm_release" "kubernetes_dashboard" {
  name             = "kubernetes-dashboard"
  create_namespace = true
  namespace        = "kubernetes-dashboard"
  chart            = "kubernetes-dashboard"
  repository       = "https://kubernetes.github.io/dashboard"
  version          = "6.0.8"

  values = [
    file("${path.module}/values/dashboard-values.yaml")
  ]

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

  set {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/security-groups"
    value = aws_security_group.central_elb_sg.id
  }

  # To share an application load balancer across multiple service resources using IngressGroups
  # To join an ingress to a group, add the following annotation to a Kubernetes ingress resource specification.
  # ref: https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html
  set {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/group\\.name"
    value = "shared-alb-group"
  }

  set {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/certificate-arn"
    value = local.map_domains[0].domain_acm
  }

  set {
    name  = "ingress.hosts[0]"
    value = "${module.this.cluster_name}-dashboard.${local.map_domains[0].domain_name}"
  }

  depends_on = [
    helm_release.dns_external,
  ]
}

#########################################################################################################
# Helm -  External-secrets
# ref: https://artifacthub.io/packages/helm/external-secrets-operator/external-secrets
#########################################################################################################
resource "helm_release" "external_secrets" {
  name       = "external-secrets"
  namespace  = "kube-system"
  chart      = "external-secrets"
  repository = "https://charts.external-secrets.io"
  version    = "0.9.4"

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.iam_role_oidc_secret_reader.arn
  }

  depends_on = [
    helm_release.kubernetes_dashboard,
  ]
}

##############################################################################################################
# ref : https://medium.com/@danieljimgarcia/dont-use-the-terraform-kubernetes-manifest-resource-6c7ff4fe629a
# ref : https://github.com/gavinbunney/terraform-provider-kubectl/issues/63
##############################################################################################################

resource "kubectl_manifest" "external_secrets_cluster_store" {
  yaml_body = <<YAML
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: global-secret-store
spec:
  provider:
    aws:
      service: SecretsManager
      region: us-east-1
      auth:
        jwt:
          serviceAccountRef:
            name: external-secrets
            namespace: kube-system
YAML

  depends_on = [
    helm_release.external_secrets,
    helm_release.kubernetes_dashboard,
  ]
}

#########################################################################################################
# Retrieve and Install External Secret for ArgoCD Dex with Github
#########################################################################################################
resource "kubernetes_namespace" "namespace_argocd" {
  metadata {
    name = "argocd"
  }

  depends_on = [
    kubectl_manifest.external_secrets_cluster_store,
  ]
}

resource "kubectl_manifest" "argocd_external_secret" {
  yaml_body = <<YAML
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: argocd-sm
  namespace: argocd
  annotations:
    "helm.sh/hook": pre-install
    "helm.sh/hook-weight": "-5"
    "helm.sh/hook-delete-policy": hook-succeeded
spec:
  refreshInterval: 30m
  secretStoreRef:
    name: global-secret-store
    kind: ClusterSecretStore
  target:
    name: argocd-sm
    creationPolicy: Owner
  data:
  - secretKey: GT_ARGOCD_ClientID
    remoteRef:
      key: devops-github-argocd
      property: ARGOCD_CLIENTID_${var.name}
  - secretKey: GT_ARGODC_ClientSecret
    remoteRef:
      key: devops-github-argocd
      property: ARGOCD_CLIENTSECRET_${var.name}
  - secretKey: GT_ARGODC_RedirectUrl
    remoteRef:
      key: devops-github-argocd
      property: ARGOCD_REDIRECTURL_${var.name}
YAML

  depends_on = [
    kubernetes_namespace.namespace_argocd,
  ]
}

#########################################################################################################
# Retrieve ARGOCD_ADMIN_PWD as AWS Secret Manager
#########################################################################################################
# Get Secret
data "aws_secretsmanager_secret_version" "get_argocd" {
  secret_id = var.secretmanagerid["github_argocd"]
}

resource "bcrypt_hash" "bcrypt_generate" {
  cleartext = jsondecode(data.aws_secretsmanager_secret_version.get_argocd.secret_string)["ARGOCD_ADMIN_PWD_${var.name}"]
}

#########################################################################################################
# Helm -  argo-cd
# ref: https://artifacthub.io/packages/helm/argo/argo-cd
#########################################################################################################
resource "helm_release" "argo_cd" {
  name             = "argo-cd"
  create_namespace = true
  namespace        = "argocd"
  chart            = "argo-cd"
  wait             = true
  repository       = "https://argoproj.github.io/argo-helm"
  version          = "5.45.5"

  values = [
    file("${path.module}/values/argocd-values.yaml")
  ]

  set {
    name  = "configs.secret.argocdServerAdminPassword"
    value = bcrypt_hash.bcrypt_generate.id
  }

  set {
    name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/security-groups"
    value = aws_security_group.central_elb_sg.id
  }

  set {
    name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/group\\.name"
    value = "shared-alb-group"
  }

  set {
    name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/certificate-arn"
    value = local.map_domains[0].domain_acm
  }

  set {
    name  = "configs.cm.url"
    value = "https://${module.this.cluster_name}-argocd.${local.map_domains[0].domain_name}"
  }

  set {
    name  = "server.ingress.hosts[0]"
    value = "${module.this.cluster_name}-argocd.${local.map_domains[0].domain_name}"
  }

  depends_on = [
    kubectl_manifest.argocd_external_secret,
  ]
}

#########################################################################################################
# Helm -  argo-rollout
# ref: https://artifacthub.io/packages/helm/argo/argo-rollouts
#########################################################################################################
resource "helm_release" "argo_rollouts" {
  name             = "argorollout"
  create_namespace = true
  namespace        = "argo-rollouts"
  chart            = "argo-rollouts"
  wait             = true
  repository       = "https://argoproj.github.io/argo-helm"
  version          = "2.30.1"

  values = [
    file("${path.module}/values/argorollout-values.yaml")
  ]

  set {
    name  = "dashboard.enabled"
    value = true
  }

  set {
    name  = "dashboard.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/security-groups"
    value = aws_security_group.central_elb_sg.id
  }

  set {
    name  = "dashboard.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/group\\.name"
    value = "shared-alb-group"
  }

  set {
    name  = "dashboard.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/certificate-arn"
    value = local.map_domains[0].domain_acm
  }

  set {
    name  = "dashboard.ingress.hosts[0]"
    value = "${module.this.cluster_name}-argorollout.${local.map_domains[0].domain_name}"
  }

  depends_on = [
    helm_release.argo_cd,
  ]
}

#########################################################################################################
# Retrieve Datadog apiKey from AWS Secret Manager
#########################################################################################################
# Get Secret
data "aws_secretsmanager_secret_version" "get_datadog" {
  secret_id = var.secretmanagerid["datadog"]
}

#########################################################################################################
# Helm -  Datadog
# ref: https://artifacthub.io/packages/helm/datadog/datadog
#########################################################################################################
resource "helm_release" "datadog" {
  name       = "datadog"
  namespace  = "kube-system"
  chart      = "datadog"
  repository = "https://helm.datadoghq.com"
  version    = "3.38.3"

  set {
    name  = "datadog.site"
    value = "datadoghq.com"
  }

  set {
    name  = "agents.enabled"
    value = true
  }

  set {
    name  = "clusterAgent.enabled"
    value = true
  }

  set {
    name  = "clusterAgent.metricsProvider.enabled"
    value = true
  }

  set {
    name  = "datadog.clusterName"
    value = module.this.cluster_name
  }

  set {
    name  = "datadog.dogstatsd.nonLocalTraffic"
    value = true
  }

  set {
    name  = "datadog.apm.enabled"
    value = true
  }

  set {
    name  = "datadog.apm.portEnabled"
    value = true
  }

  set {
    name  = "datadog.orchestratorExplorer.enabled"
    value = true
  }

  set {
    name  = "datadog.logs.enabled"
    value = true
  }

  set {
    name  = "datadog.logs.containerCollectAll"
    value = true
  }

  set {
    name  = "targetSystem"
    value = "linux"
  }

  set {
    name  = "datadog.apiKey"
    value = jsondecode(data.aws_secretsmanager_secret_version.get_datadog.secret_string)["global.apiKey"]
  }

  depends_on = [
    helm_release.argo_cd,
  ]
}


#########################################################################################################
# Retrieve Prometheus apiKey/secretid from AWS Secret Manager
#########################################################################################################
# Get Secret
data "aws_secretsmanager_secret_version" "get_promotheus" {
  secret_id = var.secretmanagerid["prometheus"]
}

#########################################################################################################
# Helm -  kube-prometheus-stack
# ref: https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack
#########################################################################################################
resource "kubernetes_storage_class" "kube_prometheus_stack_storage" {
  metadata {
    name = "kube-prometheus-stack"
  }
  storage_provisioner = "kubernetes.io/aws-ebs"
  volume_binding_mode = "WaitForFirstConsumer"
  # reclaim_policy      = "Retain"
  reclaim_policy = "Delete" //Testing
  parameters = {
    type                       = "gp3"
    encrypted                  = "true"
    fstype                     = "ext4"
    allowAutoIOPSPerGBIncrease = "true"
    kmsKeyId                   = var.kmsid
  }
  allow_volume_expansion = true

  allowed_topologies {
    match_label_expressions {
      key = "failure-domain.beta.kubernetes.io/zone"
      values = [
        "us-east-1a",
        "us-east-1b",
        "us-east-1c"
      ]
    }
  }

  depends_on = [
    helm_release.datadog,
  ]
}

resource "helm_release" "kube_prometheus_stack" {
  name             = "kube-prometheus-stack"
  create_namespace = true
  namespace        = "monitoring"
  chart            = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  version          = "51.0.3" //working Grafana v10.1.1

  values = [
    file("${path.module}/values/prometheus-stack-values.yaml")
  ]

  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName"
    value = kubernetes_storage_class.kube_prometheus_stack_storage.metadata.0.name
  }

  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage"
    value = "10Gi"
  }

  set {
    name  = "grafana.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/security-groups"
    value = aws_security_group.central_elb_sg.id
  }

  set {
    name  = "grafana.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/group\\.name"
    value = "shared-alb-group"
  }

  set {
    name  = "grafana.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/certificate-arn"
    value = local.map_domains[0].domain_acm
  }

  set {
    name  = "grafana.ingress.hosts[0]"
    value = "${module.this.cluster_name}-prometheus.${local.map_domains[0].domain_name}"
  }

  set {
    name  = "grafana.grafana\\.ini.server.root_url"
    value = "https://${module.this.cluster_name}-prometheus.${local.map_domains[0].domain_name}"
  }

  set {
    name  = "grafana.adminPassword"
    value = jsondecode(data.aws_secretsmanager_secret_version.get_promotheus.secret_string)["PROMETHEUS_ADMIN_PASSWORD"]
  }

  set {
    name  = "grafana.grafana\\.ini.auth\\.github.client_id"
    value = jsondecode(data.aws_secretsmanager_secret_version.get_promotheus.secret_string)["PROMETHEUS_CLIENTID_${var.name}"]
  }

  set {
    name  = "grafana.grafana\\.ini.auth\\.github.client_secret"
    value = jsondecode(data.aws_secretsmanager_secret_version.get_promotheus.secret_string)["PROMETHEUS_CLIENTSECRET_${var.name}"]
  }

  set {
    name  = "grafana.service.type"
    value = "ClusterIP"
  }

  depends_on = [
    kubernetes_storage_class.kube_prometheus_stack_storage,
  ]
}

#################################################################################################################################
# Configure Codefresh RBAC
#################################################################################################################################
resource "kubectl_manifest" "codefresh_clusterrole" {
  yaml_body = <<YAML
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: codefresh-role
rules:
  - apiGroups: [ "*"]
    resources: ["*"]
    verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
YAML

  depends_on = [
    helm_release.kube_prometheus_stack,
    helm_release.datadog,
  ]
}

resource "kubectl_manifest" "codefresh_serviceaccount" {
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  name: codefresh-user
  namespace: kube-system
YAML

  depends_on = [
    kubectl_manifest.codefresh_clusterrole,
  ]
}

resource "kubectl_manifest" "codefresh_clusterrolebinding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: codefresh-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: codefresh-role
subjects:
- kind: ServiceAccount
  name: codefresh-user
  namespace: kube-system
YAML

  depends_on = [
    kubectl_manifest.codefresh_serviceaccount,
  ]
}

resource "kubectl_manifest" "codefresh_secret" {
  yaml_body = <<YAML
apiVersion: v1
kind: Secret
type: kubernetes.io/service-account-token
metadata:
  name: codefresh-user-token
  namespace: kube-system
  annotations:
    kubernetes.io/service-account.name: "codefresh-user"
YAML

  depends_on = [
    kubectl_manifest.codefresh_clusterrolebinding,
  ]
}

#####################################################################################################
# Retrieve API token key from AWS Secret Manager
# Codefresh API/ACCOUNTID Access
#####################################################################################################

data "aws_secretsmanager_secret_version" "get_codefresh" {
  secret_id = var.secretmanagerid["codefresh"]
}

#########################################################################################################
# Helm -  Codefresh Runner
# ref: https://artifacthub.io/packages/helm/codefresh-runner/cf-runtime
#########################################################################################################

resource "helm_release" "codefresh" {
  name             = "cf-runtime"
  create_namespace = true
  namespace        = "codefresh"
  chart            = "cf-runtime"
  repository       = "https://chartmuseum.codefresh.io/cf-runtime"
  version = "6.1.12"

  values = [
    file("${path.module}/values/runner-values.yaml")
  ]

  set {
    name  = "global.codefreshToken"
    value = jsondecode(data.aws_secretsmanager_secret_version.get_codefresh.secret_string)["CODEFRESH_API_TOKEN"]
  }

  set {
    name  = "global.accountId"
    value = jsondecode(data.aws_secretsmanager_secret_version.get_codefresh.secret_string)["CODEFRESH_ACCOUNT_ID"]
  }

  set {
    name  = "global.context"
    value = module.this.cluster_name
  }

  set {
    name  = "runtime.dind.resources.limits.cpu"
    value = "1600m"
  }

  set {
    name  = "runtime.dind.resources.limits.memory"
    value = "4000Mi"
  }

  depends_on = [
    kubectl_manifest.codefresh_secret,
  ]

}
