# Datadog : Cloud Monitoring as a Service
Datadog is an observability service for cloud-scale applications, providing monitoring of servers, databases, tools, and services, through a SaaS-based data analytics platform.

## Prerequisites Notes
As a 3rd Party Monitoring tool, subscription to this service is required. The basic plan is free and available for testing purposes.
Before proceeding with Datadog configuration updates, ensure the Datadog service is installed. The pre-setup involves the installation of datadoghq, and you can refer to an example Helm installation guide at: https://artifacthub.io/packages/helm/datadog/datadog.

## Quickstart
Make sure awscli is configured using `aws configure`, or the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` are properly exported into the environment.

Run Terraform Install:

```bash
terraform init
terraform plan -out=plan.tfplan
terraform apply "plan.tfplan"
```

Run Terraform Uninstall:

```bash
terraform destroy -auto-approve
```

### Example Setup

```hcl

resource "datadog_logs_index" "log_index_global" {
  name           = "global"
  daily_limit    = 20000000
  retention_days = 15
  filter {
    query = "*"
  }
  exclusion_filter {
    name       = "kube_namespace_kube_system"
    is_enabled = true
    filter {
      query       = "kube_namespace:kube-system"
      sample_rate = 1.0 // 1.0 ~> 100% logs removal
    }
  }
}
```

## Author

Thinegan Ratnam
 - [http://thinegan.com](http://thinegan.com/)

## Copyright and License

Copyright 2024 Thinegan Ratnam

Code released under the MIT License.