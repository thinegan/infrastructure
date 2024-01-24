data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

data "helm_repository" "bitnami" {
  name = "bitnami"
  url  = "https://charts.bitnami.com/bitnami"
}

data "helm_repository" "kubernetes-dashboard" {
  name = "kubernetes-dashboard"
  url  = "https://kubernetes.github.io/dashboard"
}

data "helm_repository" "incubator" {
  name = "incubator"
  url  = "https://kubernetes-charts-incubator.storage.googleapis.com"
}

data "helm_repository" "vpc-cni" {
  name = "vpc-cni"
  url  = "https://aws.github.io/eks-charts"
}

data "helm_repository" "reactiveops_stable" {
  name = "reactiveops-stable"
  url  = "https://charts.reactiveops.com/stable"
}

data "helm_repository" "jetstack" {
  name = "jetstack"
  url  = "https://charts.jetstack.io"
}

data "helm_repository" "gremlin" {
  name = "gremlin"
  url  = "https://helm.gremlin.com"
}

data "helm_repository" "supergloo" {
  name = "supergloo"
  url  = "http://storage.googleapis.com/supergloo-helm"
}

data "helm_repository" "gloo" {
  name = "gloo"
  url  = "https://storage.googleapis.com/solo-public-helm"
}

data "helm_repository" "vmware_tanzu" {
  name = "vmware-tanzu"
  url  = "https://vmware-tanzu.github.io/helm-charts"
}