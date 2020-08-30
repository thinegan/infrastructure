data "aws_iam_policy_document" "worker_cluster_autoscaler" {
  statement {
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
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
        "${aws_iam_openid_connect_provider.oidc_eks_ugen.arn}",
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${aws_iam_openid_connect_provider.oidc_eks_ugen.url}:sub"

      values = [
        "system:serviceaccount:kube-system:cluster-autoscaler-aws-cluster-autoscaler"
      ]
    }
  }
}

resource "aws_iam_role" "iam_role_oidc_autoscaler" {
  name                = "dev-eks-ugen-oidc-autoscaler"
  assume_role_policy  = data.aws_iam_policy_document.oidc_autoscaler_assume_role.json
}

resource "aws_iam_policy" "iam_policy_oidc_autoscaler" {
    name              = "dev-eks-ugen-oidc-autoscaler"
    description       = "An autoscaler policy"
    policy            = data.aws_iam_policy_document.worker_cluster_autoscaler.json
}

resource "aws_iam_policy_attachment" "iam_attachment_oidc_autoscaler" {
    name              = "dev-eks-ugen-oidc-autoscaler"
    policy_arn        = aws_iam_policy.iam_policy_oidc_autoscaler.arn
    roles             = [aws_iam_role.iam_role_oidc_autoscaler.name]
}

output "oidc_autoscaler_role" {
  value = aws_iam_role.iam_role_oidc_autoscaler
}
