// AWS Provider
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform-stag-state-storage"
    key            = "timeclone/pod-DEVOPS/argocd/staging/stag-eks-test6/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "stag-terraform-state-table"
  }
}

data "terraform_remote_state" "devops_staging_secretmanager" {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "terraform-stag-state-storage"
    dynamodb_table = "stag-terraform-state-table"
    region         = "us-east-1"
    key            = "timeclone/pod-DEVOPS/aws/staging/secretmanager/terraform.tfstate"
  }
}

data "terraform_remote_state" "devops_staging_eks_test6" {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "terraform-stag-state-storage"
    dynamodb_table = "stag-terraform-state-table"
    region         = "us-east-1"
    key            = "timeclone/pod-DEVOPS/aws/staging/eks/stag-eks-test6/terraform.tfstate"
  }
}

locals {
  # Domain
  map_domains = [
    {
      domain_name = "crytera.com"
    },
  ]
}

data "aws_eks_cluster" "staging" {
  name = data.terraform_remote_state.devops_staging_eks_test6.outputs.test6_module.stag_eks_cluster.cluster_name
}

data "aws_eks_cluster_auth" "staging" {
  name = data.terraform_remote_state.devops_staging_eks_test6.outputs.test6_module.stag_eks_cluster.cluster_name
}

# NOTE: Takes sometimes for the kubernetes provider to work (DNS Propagation)
provider "kubernetes" {
  host                   = data.aws_eks_cluster.staging.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.staging.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.staging.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.staging.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.staging.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.staging.name]
      command     = "aws"
    }
  }
}

provider "kubectl" {
  host                   = data.aws_eks_cluster.staging.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.staging.certificate_authority.0.data)
  load_config_file       = false
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.staging.name]
    command     = "aws"
  }
}

#########################################################################################################
# Retrieve ARGOCD_ADMIN_PWD as AWS Secret Manager
#########################################################################################################
# Get Secret
data "aws_secretsmanager_secret_version" "get_argocd" {
  secret_id = data.terraform_remote_state.devops_staging_secretmanager.outputs.secrets_manager_github_argocd.id
}

# Get Secret
data "aws_secretsmanager_secret_version" "get_atlantisbot" {
  secret_id = data.terraform_remote_state.devops_staging_secretmanager.outputs.secrets_manager_github_atlantisbot.id
}
#########################################################################################################
provider "argocd" {
  server_addr = "${data.aws_eks_cluster.staging.name}-argocd.${local.map_domains[0].domain_name}:443"
  username    = jsondecode(data.aws_secretsmanager_secret_version.get_argocd.secret_string)["ARGOCD_ADMIN_USR_${data.aws_eks_cluster.staging.name}"]
  password    = jsondecode(data.aws_secretsmanager_secret_version.get_argocd.secret_string)["ARGOCD_ADMIN_PWD_${data.aws_eks_cluster.staging.name}"]
}
