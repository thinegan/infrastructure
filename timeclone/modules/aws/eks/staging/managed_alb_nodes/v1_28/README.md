# AWS EKS Terraform module

Terraform module to create an Elastic Kubernetes (EKS) cluster and associated resources

## Usage Example

```hcl
module "eks_staging_test6" {
  # Example EKS using Managed Nodes
  source = "modules/aws/eks/staging/managed_alb_nodes/v1_28"

  name        = "stag-eks-test6"
  pod         = "DEVOPS"
  environment = "staging"

  # Network
  vpcid              = data.terraform_remote_state.devops_staging_network.outputs.stagingVPC.id
  private_subnet_ids = data.terraform_remote_state.devops_staging_network.outputs.stagingVPC.private_subnets
  public_subnet_ids  = data.terraform_remote_state.devops_staging_network.outputs.stagingVPC.public_subnets

  # General Purpose Node Group
  gen1_node_group    = "pluto"
  gen1_instance_type = ["t3.large"]
  gen1_capacity_type = "SPOT" //SPOT or ON_DEMAND
  gen1_min_size      = 2
  gen1_max_size      = 6
  gen1_desired_size  = 2
}

output "test6_module" {
  description = "EKS module"
  value       = module.eks_staging_test6
}

output "test6_oidc" {
  description = "EKS oidc test65"
  value       = module.eks_staging_test6.stag_eks_oidc
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [terraform-aws-modules/eks/aws.this](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/19.16.0) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | the name of the eks cluster name | `string` | `""` | yes |
| <a name="input_pod"></a> [pod](#input\_pod) | A mapping of tags to assign to the eks | `string` | `""` | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | A environment of tags to assign to the eks | `string` | `""` | yes |
| <a name="input_vpcid"></a> [vpcid](#input\_vpcid) | VPC id | `string` | `""` | yes |
| <a name="input_public_subnet_ids"></a> [public_subnet_ids](#input\_public\_subnet\_ids) | public subnet ids | `list(string)` | `[]` | yes |
| <a name="input_private_subnet_ids"></a> [private_subnet_ids](#input\_private\_subnet\_ids) | private subnet ids | `list(string)` | `[]` | yes |
| <a name="input_gen1_node_group"></a> [gen1_node_group](#input\_gen1\_node\_group) | EKS Node Group | `string` | `""` | yes |
| <a name="input_gen1_instance_type"></a> [gen1_instance_type](#input\_gen1\_instance\_type) | EKS Instance type | `string` | `""` | yes |
| <a name="input_gen1_capacity_type"></a> [gen1_capacity_type](#input\_gen1\_capacity\_type) | EKS Capacity type | `string` | `""` | yes |
| <a name="input_gen1_min_size"></a> [gen1_min_size](#input\_gen1\_min\_size) | Minimum Number of Cluster Node(s) | `string` | `""` | yes |
| <a name="input_gen1_max_size"></a> [gen1_max_size](#input\_gen1\_max\_size) | Maximum Number of Cluster Node(s) | `string` | `""` | yes |
| <a name="input_gen1_desired_size"></a> [gen1_desired_size](#input\_gen1\_desired\_size) | Desired Number of Cluster Node(s) | `string` | `""` | yes |


## Outputs

| Name | Description |
|------|-------------|
| <a name="output_stag_eks_cluster"></a> [stag_eks_cluster](#output\_stag\_eks\_cluster) | The general cluster module outputs |
| <a name="output_stag_eks_oidc"></a> [stag_eks_oidc](#output\_stag\_eks\_oidc) | The OpenID Connect identity provider (issuer URL without leading `https://`) |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

