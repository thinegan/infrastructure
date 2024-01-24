data "aws_iam_policy_document" "s3_timeclone1_readonly_document" {
  statement {
    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::timeclone1",
      "arn:aws:s3:::timeclone1/*",
    ]
  }
}

resource "aws_iam_policy" "s3_timeclone1_readonly_policy" {
  name   = "s3-timeclone1-readonly"
  path   = "/"
  policy = data.aws_iam_policy_document.s3_timeclone1_readonly_document.json
}

output "s3_timeclone1_readonly_policy" {
  value = aws_iam_policy.s3_timeclone1_readonly_policy
}
