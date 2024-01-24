
module "group_dataengineer_novice" {
  source = "../../../../modules/aws/iam-group/v5_32_0"

  name = "DataEngineerNovice"
  // Note: Cannot exceed quota for PoliciesPerGroup: 10
  group_policy_arns = [
    data.terraform_remote_state.devops_staging_iam.outputs.iam_policy_manageownmfa.id,
    "arn:aws:iam::aws:policy/AWSSupportAccess",
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
    module.iam_policy_de_secretmanager_allow.id
  ]
}

output "group_dataengineer_novice" {
  value = module.group_dataengineer_novice
}

####################################################################################

module "group_dataengineer_advance" {
  source = "../../../../modules/aws/iam-group/v5_32_0"

  name = "DataEngineerAdvance"
  // Note: Cannot exceed quota for PoliciesPerGroup: 10
  group_policy_arns = [
    data.terraform_remote_state.devops_staging_iam.outputs.iam_policy_manageownmfa.id,
    "arn:aws:iam::aws:policy/AWSSupportAccess",
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonRDSPerformanceInsightsFullAccess",
    module.iam_policy_de_secretmanager_allow.id
  ]
}

output "group_dataengineer_advance" {
  value = module.group_dataengineer_advance
}

