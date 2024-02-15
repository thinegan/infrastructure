
locals {
  map_users = [
    { # User EKS Admin Access
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/rthinegan"
      username = "rthinegan"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/thinegan"
      username = "thinegan"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/terraformer"
      username = "terraformer"
      groups   = ["system:masters"]
    },
  ]

  # AWS Account ID allowed
  map_accounts = [
    "${data.aws_caller_identity.current.account_id}"
  ]

  # Domain & ssl cert to install
  map_domains = [
    {
      domain_name = "crytera.com"
      domain_acm  = "arn:aws:acm:us-east-1:${data.aws_caller_identity.current.account_id}:certificate/c0ec1332-0950-42e7-abd8-884415cbca69"
    },
  ]
}

