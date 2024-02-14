# Amazon Relational Database Service

This reference architecture provides for deploying the following AWS services :
- Amazon RDS

## Prerequisites Notes

This setup require VPC service with Private Subnets/DB Subnets readly available before creating RDS Cluster.

### Tested on the following Region:
 - US East (N. Virginia)


## Quickstart
Make sure awscli is configured using `aws configure`, or the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` are properly exported into the environment.

Run Terraform Install Secret Manager:

```bash
terraform init
terraform plan -out=plan.tfplan
terraform apply "plan.tfplan"
```

Run Terraform Uninstall Secret manager:

```bash
terraform destroy -auto-approve
```

### Example Setup

```hcl
module "rds_postgres_employee" {
  source = "../../../../../modules/aws/rds"

  name              = "employee"
  engine            = "postgres"
  engine_version    = "15"
  family            = "postgres15"
  instance_class    = "db.t3.micro"
  environment       = "staging"
  allocated_storage = 10
  jdbc_username     = local.jdbc_username
  jdbc_password     = local.jdbc_password
  port              = 5432
  pod               = "DEVOPS"
}
```

## Author

Thinegan Ratnam
 - [http://thinegan.com](http://thinegan.com/)

## Copyright and License

Copyright 2024 Thinegan Ratnam

Code released under the MIT License.