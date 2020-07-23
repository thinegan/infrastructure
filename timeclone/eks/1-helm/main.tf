provider "aws" {
  version  = "2.67"
  region   = "us-east-1"
}

data "terraform_remote_state" "dev_eks_ugen" {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "terraform-staging-state-storage"
    dynamodb_table = "terraform-staging-state-locks"
    region         = "us-east-1"
    key            = "timeclone/eks/terraform.tfstate"
  }
}

data "terraform_remote_state" "timeclone_iam" {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "terraform-staging-state-storage"
    dynamodb_table = "terraform-staging-state-locks"
    region         = "us-east-1"
    key            = "timeclone/iam/terraform.tfstate"
  }
}

data "terraform_remote_state" "timeclone_s3" {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "terraform-staging-state-storage"
    dynamodb_table = "terraform-staging-state-locks"
    region         = "us-east-1"
    key            = "timeclone/s3/terraform.tfstate"
  }
}

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform-staging-state-storage"
    dynamodb_table = "terraform-staging-state-locks"
    region         = "us-east-1"
    key            = "timeclone/eks/1-helm/release-0/terraform.tfstate"
  }
}


data "aws_eks_cluster" "staging" {
  name = data.terraform_remote_state.dev_eks_ugen.outputs.dev_eks_ugen.cluster_id
}

data "aws_eks_cluster_auth" "staging" {
  name = data.terraform_remote_state.dev_eks_ugen.outputs.dev_eks_ugen.cluster_id
}

# NOTE: Takes sometimes for the kubernetes provider to work (DNS Propagation)
provider "kubernetes" {
  host                   = data.aws_eks_cluster.staging.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.staging.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.staging.token
  load_config_file       = false
  version                = "~> 1.9"
}




# provider "aws" {
#   version = "~> 2.22"
#   region  = "us-east-1"
#   assume_role {
#     role_arn = "arn:aws:iam::964458643333:role/atlantis-exec"
#   }
# }

# data "aws_eks_cluster" "staging" {
#   name = data.terraform_remote_state.eks_mgen_ai.outputs.eks_mgen_ai.eks_cluster_name
# }

# data "aws_eks_cluster_auth" "staging" {
#   name = data.terraform_remote_state.eks_mgen_ai.outputs.eks_mgen_ai.eks_cluster_name
# }

# # NOTE: Takes sometimes for the kubernetes provider to work (DNS Propagation)
# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.staging.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.staging.certificate_authority.0.data)
#   token                  = data.aws_eks_cluster_auth.staging.token
#   load_config_file       = false
#   version                = "~> 1.8"
# }

# provider "helm" {
#   kubernetes {
#     host                   = data.aws_eks_cluster.staging.endpoint
#     cluster_ca_certificate = base64decode(data.aws_eks_cluster.staging.certificate_authority.0.data)
#     token                  = data.aws_eks_cluster_auth.staging.token
#     load_config_file       = false
#   }
#   service_account = "tiller"
#   version         = "~> 0.10.0"
# }

# data "terraform_remote_state" "eks_mgen_ai" {
#   backend = "s3"
#   config = {
#     encrypt        = true
#     bucket         = "ml-de-tf-state-storage"
#     dynamodb_table = "ml-de-ddb-tf-state-lock"
#     region         = "us-east-1"
#     key            = "ai-test/eks/stag-eks-mgen-ai/terraform.tfstate"
#   }
# }

# data "terraform_remote_state" "ai_test_iam" {
#   backend = "s3"
#   config = {
#     encrypt        = true
#     bucket         = "ml-de-tf-state-storage"
#     dynamodb_table = "ml-de-ddb-tf-state-lock"
#     region         = "us-east-1"
#     key            = "ai-test/iam/terraform.tfstate"
#   }
# }

# data "terraform_remote_state" "ai-test" {
#   backend = "s3"
#   config = {
#     encrypt        = true
#     bucket         = "ml-de-tf-state-storage"
#     dynamodb_table = "ml-de-ddb-tf-state-lock"
#     region         = "us-east-1"
#     key            = "ai-test/network/terraform.tfstate"
#   }
# }

# data "terraform_remote_state" "ai_test_s3" {
#   backend = "s3"
#   config = {
#     encrypt        = true
#     bucket         = "ml-de-tf-state-storage"
#     dynamodb_table = "ml-de-ddb-tf-state-lock"
#     region         = "us-east-1"
#     key            = "ai-test/s3/terraform.tfstate"
#   }
# }

# terraform {
#   backend "s3" {
#     encrypt        = true
#     bucket         = "ml-de-tf-state-storage"
#     dynamodb_table = "ml-de-ddb-tf-state-lock"
#     region         = "us-east-1"
#     key            = "ai-test/eks/stag-eks-mgen-ai/1-helm/release-0/terraform.tfstate"
#   }
# }

