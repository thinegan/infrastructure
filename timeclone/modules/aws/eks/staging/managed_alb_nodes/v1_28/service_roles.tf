#########################################################################################################
# AutoScaler OIDC Assume Service Roles
#########################################################################################################
data "aws_iam_policy_document" "worker_cluster_autoscaler" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/k8s.io/cluster-autoscaler/enabled"
      values   = ["true"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/k8s.io/cluster-autoscaler/${var.name}"
      values   = ["owned"]
    }
  }

  statement {
    sid    = ""
    effect = "Allow"
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions",
      "ec2:DescribeInstanceTypes"
    ]

    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "oidc_autoscaler_assume_role" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    principals {
      type = "Federated"
      identifiers = [
        module.this.oidc_provider_arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${module.this.oidc_provider}:sub"
      values = [
        "system:serviceaccount:kube-system:cluster-autoscaler-aws-cluster-autoscaler"
      ]
    }
  }
}

# Create role with policy and trusted relationships attached
resource "aws_iam_role" "iam_role_oidc_autoscaler" {
  name               = "${var.name}-oidc-autoscaler"
  assume_role_policy = data.aws_iam_policy_document.oidc_autoscaler_assume_role.json
  inline_policy {
    name   = "worker_cluster_autoscaler_policy"
    policy = jsonencode(jsondecode(data.aws_iam_policy_document.worker_cluster_autoscaler.json))
  }

  depends_on = [
    module.this
  ]
}

output "iam_role_oidc_autoscaler_role" {
  value = aws_iam_role.iam_role_oidc_autoscaler
}


##############################################################################################################################
# AWS Load Balancer OIDC Assume Service Roles
# ref: https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json
##############################################################################################################################

data "aws_iam_policy_document" "worker_cluster_aws_load_balancer_controller" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]
    actions   = ["iam:CreateServiceLinkedRole"]

    condition {
      test     = "StringEquals"
      variable = "iam:AWSServiceName"
      values   = ["elasticloadbalancing.amazonaws.com"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeVpcs",
      "ec2:DescribeVpcPeeringConnections",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeInstances",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeTags",
      "ec2:GetCoipPoolUsage",
      "ec2:DescribeCoipPools",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeListenerCertificates",
      "elasticloadbalancing:DescribeSSLPolicies",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:DescribeTags",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "cognito-idp:DescribeUserPoolClient",
      "acm:ListCertificates",
      "acm:DescribeCertificate",
      "iam:ListServerCertificates",
      "iam:GetServerCertificate",
      "waf-regional:GetWebACL",
      "waf-regional:GetWebACLForResource",
      "waf-regional:AssociateWebACL",
      "waf-regional:DisassociateWebACL",
      "wafv2:GetWebACL",
      "wafv2:GetWebACLForResource",
      "wafv2:AssociateWebACL",
      "wafv2:DisassociateWebACL",
      "shield:GetSubscriptionState",
      "shield:DescribeProtection",
      "shield:CreateProtection",
      "shield:DeleteProtection",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupIngress",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]
    actions   = ["ec2:CreateSecurityGroup"]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:ec2:*:*:security-group/*"]
    actions   = ["ec2:CreateTags"]

    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"
      values   = ["CreateSecurityGroup"]
    }

    condition {
      test     = "Null"
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:ec2:*:*:security-group/*"]

    actions = [
      "ec2:CreateTags",
      "ec2:DeleteTags",
    ]

    condition {
      test     = "Null"
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
      values   = ["true"]
    }

    condition {
      test     = "Null"
      variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:DeleteSecurityGroup",
    ]

    condition {
      test     = "Null"
      variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateTargetGroup",
    ]

    condition {
      test     = "Null"
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:CreateRule",
      "elasticloadbalancing:DeleteRule",
    ]
  }

  statement {
    sid    = ""
    effect = "Allow"

    resources = [
      "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
      "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
      "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*",
    ]

    actions = [
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:RemoveTags",
    ]

    condition {
      test     = "Null"
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
      values   = ["true"]
    }

    condition {
      test     = "Null"
      variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    sid    = ""
    effect = "Allow"

    resources = [
      "arn:aws:elasticloadbalancing:*:*:listener/net/*/*/*",
      "arn:aws:elasticloadbalancing:*:*:listener/app/*/*/*",
      "arn:aws:elasticloadbalancing:*:*:listener-rule/net/*/*/*",
      "arn:aws:elasticloadbalancing:*:*:listener-rule/app/*/*/*",
    ]

    actions = [
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:RemoveTags",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:SetIpAddressType",
      "elasticloadbalancing:SetSecurityGroups",
      "elasticloadbalancing:SetSubnets",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:DeleteTargetGroup",
    ]

    condition {
      test     = "Null"
      variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    sid    = ""
    effect = "Allow"

    resources = [
      "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
      "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
      "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*",
    ]

    actions = ["elasticloadbalancing:AddTags"]

    condition {
      test     = "StringEquals"
      variable = "elasticloadbalancing:CreateAction"

      values = [
        "CreateTargetGroup",
        "CreateLoadBalancer",
      ]
    }

    condition {
      test     = "Null"
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:elasticloadbalancing:*:*:targetgroup/*/*"]

    actions = [
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:DeregisterTargets",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "elasticloadbalancing:SetWebAcl",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:AddListenerCertificates",
      "elasticloadbalancing:RemoveListenerCertificates",
      "elasticloadbalancing:ModifyRule",
    ]
  }
}

data "aws_iam_policy_document" "oidc_aws_load_balancer_controller_assume_role" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    principals {
      type = "Federated"
      identifiers = [
        module.this.oidc_provider_arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${module.this.oidc_provider}:sub"

      values = [
        "system:serviceaccount:kube-system:aws-load-balancer-controller"
      ]
    }
  }
}

# Create role with policy and trusted relationships attached
resource "aws_iam_role" "iam_role_oidc_load_balancer_controller" {
  name               = "${var.name}-oidc-load-balancer-controller"
  assume_role_policy = data.aws_iam_policy_document.oidc_aws_load_balancer_controller_assume_role.json
  inline_policy {
    name   = "worker_cluster_aws_load_balancer_controller_policy"
    policy = jsonencode(jsondecode(data.aws_iam_policy_document.worker_cluster_aws_load_balancer_controller.json))
  }

  depends_on = [
    module.this
  ]
}

output "iam_role_oidc_load_balancer_controller_role" {
  value = aws_iam_role.iam_role_oidc_load_balancer_controller
}


#########################################################################################################
# External DNS OIDC Assume Service Roles
# ref: https://aws.amazon.com/premiumsupport/knowledge-center/eks-set-up-externaldns/
#########################################################################################################

data "aws_iam_policy_document" "worker_external_dns" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:route53:::hostedzone/*"]
    actions   = ["route53:ChangeResourceRecordSets"]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
    ]
  }
}

data "aws_iam_policy_document" "oidc_external_dns_assume_role" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    principals {
      type = "Federated"
      identifiers = [
        module.this.oidc_provider_arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${module.this.oidc_provider}:sub"

      values = [
        "system:serviceaccount:kube-system:external-dns"
      ]
    }
  }
}

# Create role with policy and trusted relationships attached
resource "aws_iam_role" "iam_role_oidc_external_dns" {
  name               = "${var.name}-oidc-external-dns"
  assume_role_policy = data.aws_iam_policy_document.oidc_external_dns_assume_role.json
  inline_policy {
    name   = "worker_external_dns_policy"
    policy = jsonencode(jsondecode(data.aws_iam_policy_document.worker_external_dns.json))
  }

  depends_on = [
    module.this
  ]
}

output "iam_role_oidc_external_dns_role" {
  value = aws_iam_role.iam_role_oidc_external_dns
}

#########################################################################################################
# External-Secret OIDC Assume Service Roles
#########################################################################################################

data "aws_iam_policy_document" "worker_secret_reader" {
  statement {
    actions = [
      "secretsmanager:ListSecrets",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "kms:Decrypt"
    ]

    resources = [
      var.kmsid,
    ]
  }

}

data "aws_iam_policy_document" "oidc_secret_reader_assume_role" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    principals {
      type = "Federated"
      identifiers = [
        module.this.oidc_provider_arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${module.this.oidc_provider}:sub"
      values = [
        "system:serviceaccount:kube-system:external-secrets",
      ]
    }
  }
}

# Create role with policy and trusted relationships attached
resource "aws_iam_role" "iam_role_oidc_secret_reader" {
  name               = "${var.name}-oidc-secret-reader"
  assume_role_policy = data.aws_iam_policy_document.oidc_secret_reader_assume_role.json
  inline_policy {
    name   = "worker_cluster_secret_reader_policy"
    policy = jsonencode(jsondecode(data.aws_iam_policy_document.worker_secret_reader.json))
  }

  depends_on = [
    module.this
  ]
}

output "iam_role_oidc_secret_reader_role" {
  value = aws_iam_role.iam_role_oidc_secret_reader
}

#########################################################################################################
# Amazon EBS CSI driver OIDC Assume Service Roles
# EBS encrypt via eks main (ebs_kms_key module)
# https://docs.aws.amazon.com/eks/latest/userguide/csi-iam-role.html
# You don't need these config, as eks modules already included all the relevant config by default.
#########################################################################################################

data "aws_iam_policy_document" "worker_amazon_ebs_csi_driver" {

  statement {
    sid       = "ebskms1"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "kms:Decrypt",
      "kms:CreateGrant",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
  }
}

data "aws_iam_policy_document" "oidc_amazon_ebs_csi_driver_assume_role" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    principals {
      type = "Federated"
      identifiers = [
        module.this.oidc_provider_arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${module.this.oidc_provider}:sub"

      values = [
        "system:serviceaccount:kube-system:ebs-csi-controller-sa"
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "${module.this.oidc_provider}:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }
  }
}

# Create role with policy and trusted relationships attached
resource "aws_iam_role" "iam_role_oidc_amazon_ebs_csi_driver" {
  name                = "${var.name}-oidc-amazon_ebs_csi_driver"
  assume_role_policy  = data.aws_iam_policy_document.oidc_amazon_ebs_csi_driver_assume_role.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"]

  inline_policy {
    name   = "worker_oidc-amazon_ebs_csi_driver_policy"
    policy = jsonencode(jsondecode(data.aws_iam_policy_document.worker_amazon_ebs_csi_driver.json))
  }

  depends_on = [
    module.this
  ]
}

output "iam_role_oidc_amazon_ebs_csi_driver_role" {
  value = aws_iam_role.iam_role_oidc_amazon_ebs_csi_driver
}
