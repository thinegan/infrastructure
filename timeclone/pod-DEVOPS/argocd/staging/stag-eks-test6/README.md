# Argocd post configuration
Argo CD applications, projects and settings can be defined declaratively using Kubernetes manifests.

## Prerequisites Notes
Before proceeding with updating the ArgoCD configuration, ensure that the ArgoCD service is installed. The pre-setup involves installing ArgoCD, and an example Helm installation guide can be found at: https://artifacthub.io/packages/helm/argo/argo-cd.

For the post-setup of ArgoCD, it encompasses the installation of repositories, projects, service accounts, cluster roles, and role bindings.

## Tested on the following Region:
 - US East (N. Virginia)

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
# Public Helm repository
resource "argocd_repository" "public_helm_nginx" {
  repo = "https://helm.nginx.com/stable"
  name = "nginx-stable"
  type = "helm"
}

# Private Git repository
resource "argocd_repository" "thinegan_infrastructure" {
  repo     = "https://github.com/thinegan/infrastructure.git"
  username = jsondecode(data.aws_secretsmanager_secret_version.get_atlantisbot.secret_string)["GITHUB_OWNER"]
  password = jsondecode(data.aws_secretsmanager_secret_version.get_atlantisbot.secret_string)["GITHUB_TOKEN"]
}
```

## Author

Thinegan Ratnam
 - [http://thinegan.com](http://thinegan.com/)

## Copyright and License

Copyright 2024 Thinegan Ratnam

Code released under the MIT License.