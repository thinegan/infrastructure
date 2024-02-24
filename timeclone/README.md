# Self Service Infra and Github Operations Example

## Overview
This project is designed to streamline and automate infrastructure management through self-service modules and GitHub operations facilitated by Atlantis. The structure follows best practices, embracing the principles of Infrastructure as Code (IAC) to simplify deployment complexities and enhance the developer experience.

## Module Structure
Our self-contained modules for AWS, Codefresh, and GitHub adhere to coding best practices, promoting clear organization and adhering to the DRY ("Don't Repeat Yourself") principle. Each module is versioned by creating separate directories, emphasizing immutability for easy upgrades.

### AWS Modules:
* modules/aws
* * ecr
* * * v1_6_0
* * eks
* * iam-group
* * iam-policy
* * iam-user
* * rds
* * s3
* * secretmanager
* * vpc

### Codefresh Modules:
* modules/codefresh
* * cfpipe

### GitHub Modules:
* modules/github
* * repository
* * team_membership

## Pod Structure
* pod-DE (Data Engineering)
* pod-DEVOPS (DEVOPS/SRE)

The modular approach extends to pods, allowing teams to own their resources and services with granular access controls. Teams, such as 'pod-DE' (Data Engineering) and 'pod-DEVOPS' (DevOps/SRE), manage their resources independently. Pods can also share resources, fostering a shared responsibility model. For example, the 'pod-DevOps' team governs an EKS cluster, enabling other pods to leverage this shared service for their APIs and services.

By structuring our infrastructure in this way, we empower teams to efficiently manage their resources, promote collaboration, and ensure a secure, governed framework for self-service operations.
