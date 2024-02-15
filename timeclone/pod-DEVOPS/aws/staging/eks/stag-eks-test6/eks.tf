##################################################################################################################
# Note: To terminate EKS cluster using module use this command in the github 
# comment: "atlantis plan -- -destroy" or "terraform destroy -auto-approve"
# Due to race condition, you can't comment-out inorder to terminate the eks cluster
##################################################################################################################

##################################################################################################################
# Create EKS Cluster
# ref issue: https://github.com/terraform-aws-modules/terraform-aws-eks/issues/835
# Please note : instance scaling required 2-step to avoid,
# Minimum capacity X can't be greater than desired size X fail error"
# Step 1: Increase the desired_size (< max_size) and apply
# Step 2: Increase the min_size ( <= desired_size) and apply
##################################################################################################################
module "eks_staging_test6" {
  # Example EKS using Managed Nodes
  source = "../../../../../modules/aws/eks/staging/managed_alb_nodes/v1_28"
  # source = "../../../../../modules/aws/eks/staging/managed_nginx_nodes/v1_28"
  # source = "../../../../../modules/aws/eks/staging/managed_nginx_nodes_istio/v1_28"
  # source = "../../../../../modules/aws/eks/staging/managed_alb_nodes_istio/v1_28"
  # source = "../../../../../modules/aws/eks/staging/managed_alb_nodes_fargate/v1_28"

  name        = "stag-eks-test6"
  pod         = "DEVOPS"
  environment = "staging"

  # Network
  vpcid              = data.terraform_remote_state.devops_staging_network.outputs.stagingVPC.id
  private_subnet_ids = data.terraform_remote_state.devops_staging_network.outputs.stagingVPC.private_subnets
  public_subnet_ids  = data.terraform_remote_state.devops_staging_network.outputs.stagingVPC.public_subnets

  # KMS
  kmsid = data.terraform_remote_state.devops_staging_kms.outputs.kms_timeclone_dev.key_arn

  # Secretmanager
  secretmanagerid = {
    codefresh     = data.terraform_remote_state.devops_staging_secretmanager.outputs.secrets_manager_codefresh.id
    github_argocd = data.terraform_remote_state.devops_staging_secretmanager.outputs.secrets_manager_github_argocd.id
    datadog       = data.terraform_remote_state.devops_staging_secretmanager.outputs.secrets_manager_datadog.id
    prometheus    = data.terraform_remote_state.devops_staging_secretmanager.outputs.secrets_manager_prometheus.id
    cloudflare    = data.terraform_remote_state.devops_staging_secretmanager.outputs.secrets_manager_cloudflare.id
  }

  # General Purpose Node Group
  gen1_node_group    = "pluto"
  gen1_instance_type = ["t3.large"]
  gen1_capacity_type = "SPOT" //SPOT or ON_DEMAND
  gen1_min_size      = 2
  gen1_max_size      = 6
  gen1_desired_size  = 2

}

# EKS Output
output "test6_module" {
  description = "EKS module"
  value       = module.eks_staging_test6
}

output "test6_oidc" {
  description = "EKS oidc test66"
  value       = module.eks_staging_test6.stag_eks_oidc
}

#######################################################################################################################
