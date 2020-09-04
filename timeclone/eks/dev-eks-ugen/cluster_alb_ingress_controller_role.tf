data "aws_iam_policy_document" "worker_cluster_alb_ingress_controller" {
  statement {
    actions = [
      "acm:DescribeCertificate",
      "acm:ListCertificates",
      "acm:GetCertificate",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "ec2:DeleteSecurityGroup",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVpcs",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:RevokeSecurityGroupIngress",
      "elasticloadbalancing:AddListenerCertificates",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateRule",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteRule",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:DescribeListenerCertificates",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeSSLPolicies",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:ModifyRule",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:RemoveListenerCertificates",
      "elasticloadbalancing:RemoveTags",
      "elasticloadbalancing:SetIpAddressType",
      "elasticloadbalancing:SetSecurityGroups",
      "elasticloadbalancing:SetSubnets",
      "elasticloadbalancing:SetWebACL",
      "iam:CreateServiceLinkedRole",
      "iam:GetServerCertificate",
      "iam:ListServerCertificates",
      "cognito-idp:DescribeUserPoolClient",
      "waf-regional:GetWebACLForResource",
      "waf-regional:GetWebACL",
      "waf-regional:AssociateWebACL",
      "waf-regional:DisassociateWebACL",
      "tag:GetResources",
      "tag:TagResources",
      "waf:GetWebACL"
    ]

    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "oidc_alb_ingress_controller_assume_role" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    principals {
      type = "Federated"  
      identifiers = [
        "${aws_iam_openid_connect_provider.oidc_eks_ugen.arn}",
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${aws_iam_openid_connect_provider.oidc_eks_ugen.url}:sub"

      values = [
        "system:serviceaccount:kube-system:alb-ingress-controller-aws-alb-ingress-controller"
      ]
    }
  }
}


resource "aws_iam_role" "iam_role_oidc_alb_ingress_controller" {
  name                = "dev-eks-ugen-oidc-alb-ingress-controller"
  assume_role_policy  = data.aws_iam_policy_document.oidc_alb_ingress_controller_assume_role.json
}

resource "aws_iam_policy" "iam_policy_oidc_alb_ingress_controller" {
    name              = "dev-eks-ugen-oidc-alb-ingress-controller"
    description       = "An example policy"
    policy            = data.aws_iam_policy_document.worker_cluster_alb_ingress_controller.json
}

resource "aws_iam_policy_attachment" "iam_attachment_oidc_alb_ingress_controller" {
    name              = "dev-eks-ugen-oidc-alb-ingress-controller"
    policy_arn        = aws_iam_policy.iam_policy_oidc_alb_ingress_controller.arn
    roles             = [aws_iam_role.iam_role_oidc_alb_ingress_controller.name]
}


output "oidc_alb_ingress_controller_role" {
  value = aws_iam_role.iam_role_oidc_alb_ingress_controller
}
