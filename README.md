# Self Service Infra and Github Operations (using Atlantis) Example


## Objective

The goal is to demonstrate the implementation of a robust CI/CD platform (Codefresh) integrated with a leading cloud provider (AWS) using Infrastructure as Code (IAC). This initiative aims to empower teams within the company or startup by providing a streamlined and self-service approach to onboarding and service rollout. Through this solution, we aspire to enhance the developer experience within a secure and well-governed framework, ultimately fostering efficiency and agility in our development processes.

## Core Modules/Resources
* Collection of Terraform AWS modules supported by the community 🇺🇦 - [terraform-aws-modules](https://registry.terraform.io/namespaces/terraform-aws-modules)
* Codefresh is a container-native CI/CD platform - [codefresh](https://registry.terraform.io/providers/codefresh-io/codefresh/0.7.0-beta-1/docs/resources/pipeline)
* Github Repository - [github](https://registry.terraform.io/providers/integrations/github/6.0.0-beta/docs/resources/repository)
* Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes - [argocd](https://registry.terraform.io/providers/jmcconnell26/argocd/0.0.12/docs/resources/repository)
* Cloudflare, DNS tool - [cloudflare](https://registry.terraform.io/providers/cloudflare/cloudflare/4.23.0/docs/resources/record)
* Datadog, Monitoring and analytics tool - [datadog](https://registry.terraform.io/providers/DataDog/datadog/3.35.0/docs/resources/logs_index)
* Twingate, Zero Trust Network Access (ZTNA) - [twingate](https://artifacthub.io/packages/helm/connector/connector)