resource "kubernetes_service_account" "codefresh" {
  metadata {
    name      = "codefresh-user"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role" "codefresh" {
  metadata {
    name = "codefresh-role"
  }

  rule {
    api_groups = [""]
    resources  = ["*"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods/portforward"]
    verbs      = ["create"]
  }

  rule {
    api_groups = ["bitnami.com"]
    resources  = ["sealedsecrets"]
    verbs      = ["get", "create", "patch"]
  }

  rule {
    api_groups = ["extensions", "apps"]
    resources  = ["replicasets", "deployments"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
}

resource "kubernetes_cluster_role_binding" "codefresh" {
  metadata {
    name = "codefresh-user"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "codefresh-role"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "codefresh-user"
    namespace = "kube-system"
  }
}
