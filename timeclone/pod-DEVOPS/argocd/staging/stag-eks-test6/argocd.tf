#################################################################################################################################
# Post-Setup ArgoCD
# Running This will require VPN connection available before running this
#################################################################################################################################

################################################################################################################
# Add repo update4
################################################################################################################

# Public Helm repository
resource "argocd_repository" "public_helm_kube_state_metrics" {
  repo = "https://kubernetes.github.io/kube-state-metrics"
  name = "kube-state-metrics"
  type = "helm"
}

# Public Helm repository
resource "argocd_repository" "public_helm_pixie_operator_charts" {
  repo = "https://pixie-operator-charts.storage.googleapis.com"
  name = "pixie-operator-charts"
  type = "helm"
}

# Public Helm repository
resource "argocd_repository" "public_helm_nginx" {
  repo = "https://helm.nginx.com/stable"
  name = "nginx-stable"
  type = "helm"
}

# Private Git repository
resource "argocd_repository" "crytera_infrastructure" {
  repo     = "https://github.com/crytera/infrastructure.git"
  username = jsondecode(data.aws_secretsmanager_secret_version.get_atlantisbot.secret_string)["GITHUB_OWNER"]
  password = jsondecode(data.aws_secretsmanager_secret_version.get_atlantisbot.secret_string)["GITHUB_TOKEN"]
}

# Private Git repository
resource "argocd_repository" "crytera_codefresh" {
  repo     = "https://github.com/crytera/codefresh.git"
  username = jsondecode(data.aws_secretsmanager_secret_version.get_atlantisbot.secret_string)["GITHUB_OWNER"]
  password = jsondecode(data.aws_secretsmanager_secret_version.get_atlantisbot.secret_string)["GITHUB_TOKEN"]
}

# Private Git repository
resource "argocd_repository" "crytera_codefresh_gitops" {
  repo     = "https://github.com/crytera/codefresh-gitops.git"
  username = jsondecode(data.aws_secretsmanager_secret_version.get_atlantisbot.secret_string)["GITHUB_OWNER"]
  password = jsondecode(data.aws_secretsmanager_secret_version.get_atlantisbot.secret_string)["GITHUB_TOKEN"]
}

# Private Git repository
resource "argocd_repository" "crytera_templateapi" {
  repo     = "https://github.com/crytera/templateapi.git"
  username = jsondecode(data.aws_secretsmanager_secret_version.get_atlantisbot.secret_string)["GITHUB_OWNER"]
  password = jsondecode(data.aws_secretsmanager_secret_version.get_atlantisbot.secret_string)["GITHUB_TOKEN"]
}

# Private Git repository
resource "argocd_repository" "crytera_templatejs" {
  repo     = "https://github.com/crytera/templatejs.git"
  username = jsondecode(data.aws_secretsmanager_secret_version.get_atlantisbot.secret_string)["GITHUB_OWNER"]
  password = jsondecode(data.aws_secretsmanager_secret_version.get_atlantisbot.secret_string)["GITHUB_TOKEN"]
}

# Private Git repository
resource "argocd_repository" "crytera_templatenginx" {
  repo     = "https://github.com/crytera/templatenginx.git"
  username = jsondecode(data.aws_secretsmanager_secret_version.get_atlantisbot.secret_string)["GITHUB_OWNER"]
  password = jsondecode(data.aws_secretsmanager_secret_version.get_atlantisbot.secret_string)["GITHUB_TOKEN"]
}

# Private Git repository
resource "argocd_repository" "crytera_templatephpfpm" {
  repo     = "https://github.com/crytera/templatephpfpm.git"
  username = jsondecode(data.aws_secretsmanager_secret_version.get_atlantisbot.secret_string)["GITHUB_OWNER"]
  password = jsondecode(data.aws_secretsmanager_secret_version.get_atlantisbot.secret_string)["GITHUB_TOKEN"]
}

# Private Git repository
resource "argocd_repository" "crytera_templaterollout" {
  repo     = "https://github.com/crytera/templaterollout.git"
  username = jsondecode(data.aws_secretsmanager_secret_version.get_atlantisbot.secret_string)["GITHUB_OWNER"]
  password = jsondecode(data.aws_secretsmanager_secret_version.get_atlantisbot.secret_string)["GITHUB_TOKEN"]
}

# Private Git repository
resource "argocd_repository" "crytera_templateloadbalancer" {
  repo     = "https://github.com/crytera/templateloadbalancer.git"
  username = jsondecode(data.aws_secretsmanager_secret_version.get_atlantisbot.secret_string)["GITHUB_OWNER"]
  password = jsondecode(data.aws_secretsmanager_secret_version.get_atlantisbot.secret_string)["GITHUB_TOKEN"]
}

# Private Git repository
resource "argocd_repository" "crytera_templateingress" {
  repo     = "https://github.com/crytera/templateingress.git"
  username = jsondecode(data.aws_secretsmanager_secret_version.get_atlantisbot.secret_string)["GITHUB_OWNER"]
  password = jsondecode(data.aws_secretsmanager_secret_version.get_atlantisbot.secret_string)["GITHUB_TOKEN"]
}

# Private Git repository
resource "argocd_repository" "crytera_templateistio" {
  repo     = "https://github.com/crytera/templateistio.git"
  username = jsondecode(data.aws_secretsmanager_secret_version.get_atlantisbot.secret_string)["GITHUB_OWNER"]
  password = jsondecode(data.aws_secretsmanager_secret_version.get_atlantisbot.secret_string)["GITHUB_TOKEN"]
}

# Private Git repository
resource "argocd_repository" "crytera_templatenginxistio" {
  repo     = "https://github.com/crytera/templatenginxistio.git"
  username = jsondecode(data.aws_secretsmanager_secret_version.get_atlantisbot.secret_string)["GITHUB_OWNER"]
  password = jsondecode(data.aws_secretsmanager_secret_version.get_atlantisbot.secret_string)["GITHUB_TOKEN"]
}

# Private Git repository
resource "argocd_repository" "crytera_templatefargate" {
  repo     = "https://github.com/crytera/templatefargate.git"
  username = jsondecode(data.aws_secretsmanager_secret_version.get_atlantisbot.secret_string)["GITHUB_OWNER"]
  password = jsondecode(data.aws_secretsmanager_secret_version.get_atlantisbot.secret_string)["GITHUB_TOKEN"]
}

# Public Git example repository
resource "argocd_repository" "public_argocd_example" {
  repo = "https://github.com/argoproj/argocd-example-apps.git"
  name = "guestbook"
}

################################################################################################################
# Add Service
################################################################################################################
resource "kubernetes_service_account" "argocd_manager" {
  # ref : https://github.com/hashicorp/terraform-provider-kubernetes/issues/1990
  # note : Once versions that are older than 1.24 are not supported anymore, we will then remove this warning message.
  metadata {
    name      = "argocd-manager"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role" "argocd_manager" {
  metadata {
    name = "argocd-manager-role"
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }

  rule {
    non_resource_urls = ["*"]
    verbs             = ["*"]
  }
}

resource "kubernetes_cluster_role_binding" "argocd_manager" {
  metadata {
    name = "argocd-manager-role-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.argocd_manager.metadata.0.name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.argocd_manager.metadata.0.name
    namespace = kubernetes_service_account.argocd_manager.metadata.0.namespace
  }
}

resource "kubernetes_secret" "argocd_manager" {
  metadata {
    name      = kubernetes_service_account.argocd_manager.metadata.0.name
    namespace = kubernetes_service_account.argocd_manager.metadata.0.namespace
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.argocd_manager.metadata.0.name
    }
  }
  type = "kubernetes.io/service-account-token"
}


################################################################################################################
## AWS EKS cluster
## Generate Argo Token (one time install)
################################################################################################################
data "aws_eks_cluster" "staging_cluster" {
  name = data.terraform_remote_state.devops_staging_eks_test6.outputs.test6_module.stag_eks_cluster.cluster_name
}

data "kubernetes_secret" "argocd_manager" {
  metadata {
    name      = kubernetes_service_account.argocd_manager.metadata.0.name
    namespace = kubernetes_service_account.argocd_manager.metadata.0.namespace
  }

  depends_on = [
    kubernetes_secret.argocd_manager,
  ]
}

## Bearer token Authentication
resource "argocd_cluster" "kubernetes" {
  server = format("%s", data.aws_eks_cluster.staging_cluster.endpoint)
  name   = data.aws_eks_cluster.staging_cluster.name

  config {
    bearer_token = data.kubernetes_secret.argocd_manager.data["token"]
    tls_client_config {
      ca_data = base64decode(data.aws_eks_cluster.staging_cluster.certificate_authority[0].data)
    }
  }
  depends_on = [
    data.kubernetes_secret.argocd_manager,
  ]
}

################################################################################################################
# Add Projects
################################################################################################################

resource "argocd_project" "project_infrastructure" {
  metadata {
    name = "infrastructure"
    labels = {
      acceptance = "true"
    }
    annotations = {
      "this.is.a.really.long.nested.key" = "yes, really!"
    }
  }

  spec {
    description = "all related services/system projects"

    source_namespaces = ["*"]
    source_repos      = ["*"]

    destination {
      server    = "*"
      namespace = "*"
    }

    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }

    namespace_resource_whitelist {
      group = "*"
      kind  = "*"
    }
  }
}

resource "argocd_project" "project_product" {
  metadata {
    name = "product"
    labels = {
      acceptance = "true"
    }
  }

  spec {
    description = "all related product projects"

    source_namespaces = ["*"]
    source_repos      = ["*"]

    destination {
      server    = "*"
      namespace = "*"
    }

    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }

    namespace_resource_whitelist {
      group = "*"
      kind  = "*"
    }
  }
}