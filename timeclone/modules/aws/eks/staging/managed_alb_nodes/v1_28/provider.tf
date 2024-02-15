

data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

#########################################################################################################
# Kubernetes -  Provider
#########################################################################################################

provider "kubernetes" {
  host                   = module.this.cluster_endpoint
  cluster_ca_certificate = base64decode(module.this.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.this.cluster_name]
  }
}

#########################################################################################################
# Helm -  Provider
#########################################################################################################
provider "helm" {
  kubernetes {
    host                   = module.this.cluster_endpoint
    cluster_ca_certificate = base64decode(module.this.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.this.cluster_name]
    }
  }
}

#########################################################################################################
# kubectl -  Provider
#########################################################################################################

provider "kubectl" {
  host                   = module.this.cluster_endpoint
  cluster_ca_certificate = base64decode(module.this.cluster_certificate_authority_data)
  load_config_file       = false
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.this.cluster_name]
  }
}
