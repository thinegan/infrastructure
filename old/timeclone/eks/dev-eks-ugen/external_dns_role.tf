data "aws_iam_policy_document" "worker_external_dns" {
  statement {
    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
      "route53:ChangeResourceRecordSets"
    ]

    resources = [
      "*",
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
        "${aws_iam_openid_connect_provider.oidc_eks_ugen.arn}",
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${aws_iam_openid_connect_provider.oidc_eks_ugen.url}:sub"

      values = [
        "system:serviceaccount:kube-system:dns-external-staging-external-dns",
      ]
    }
  }
}

resource "aws_iam_role" "iam_role_oidc_external_dns" {
  name                = "dev-eks-ugen-oidc-external-dns"
  assume_role_policy  = data.aws_iam_policy_document.oidc_external_dns_assume_role.json
}

resource "aws_iam_policy" "iam_policy_oidc_external_dns" {
    name              = "dev-eks-ugen-oidc-external-dns"
    description       = "An external dns policy"
    policy            = data.aws_iam_policy_document.worker_external_dns.json
}

resource "aws_iam_policy_attachment" "iam_attachment_oidc_external_dns" {
    name              = "dev-eks-ugen-oidc-external-dns"
    policy_arn        = aws_iam_policy.iam_policy_oidc_external_dns.arn
    roles             = [aws_iam_role.iam_role_oidc_external_dns.name]
}

output "oidc_external_dns_role" {
  value = aws_iam_role.iam_role_oidc_external_dns
}

