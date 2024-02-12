# Identity and Access Management (IAM)

This reference architecture provides for deploying the following AWS services :
- Amazon IAM User
- Amazon IAM Group
- Amazon IAM Role
- Amazon IAM Policy

## Prerequisites Notes
IAM User module use "https://api.mailersend.com/v1/email" api to send email notification to the newly created user. Configure the api key token and username in the AWS Secret Manager before using this module. Altrernatively you can comment out to disable email notification.

### Tested on the following Region:
 - US East (N. Virginia)

## Quickstart
Make sure awscli is configured using `aws configure`, or the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` are properly exported into the environment.

Run Terraform Install IAM:

```bash
terraform init
terraform plan -out=plan.tfplan
terraform apply "plan.tfplan"
```

Run Terraform Uninstall IAM:

```bash
terraform destroy -auto-approve
```

### Example Setup

```hcl
#########################################
# IAM user, login profile and access key
#########################################
module "user_EveBrown" {
  source = "../../../../modules/aws/iam-user/v5_32_0"

  username = "EveBrown"
  fullname = "Eve Brown"
  email    = "EveBrown@crytera.com"
  tags     = local.tags

  // Attach with all relevant group(s)
  groups = [
    module.group_dataengineer_advance.group_name,
    module.group_dataengineer_novice.group_name
  ]

  // Custom policy dedicated for this user only
  policy_arns = [
    module.iam_staging_s3_readonly_timeclone_dev1.arn
  ]
}

# ECR Output info
output "user_EveBrown" {
  value = module.user_EveBrown
}

```

## Author

Thinegan Ratnam
 - [http://thinegan.com](http://thinegan.com/)

## Copyright and License

Copyright 2024 Thinegan Ratnam

Code released under the MIT License.