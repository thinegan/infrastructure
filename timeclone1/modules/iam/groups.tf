# Group Name
resource "aws_iam_group" "developers" {
  name = "developers"
}

resource "aws_iam_group" "devops" {
  name = "devops"
}

resource "aws_iam_group" "dataengineer" {
  name = "dataengineer"
}

resource "aws_iam_group" "sre" {
  name = "sre"
}

# Attach Users to Group
resource "aws_iam_group_membership" "group_devops_membership" {
  name = "tf-group_devops_membership"
  users = [
    module.iam_user_ratnam.this_iam_user_name,
  ]
  group = aws_iam_group.devops.id
}

# Create Inline Policy to Group
resource "aws_iam_group_policy" "my_devops_policy" {
  name  = "my_devops_policy"
  group = aws_iam_group.devops.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# Attach Managed Policy to Group
resource "aws_iam_group_policy_attachment" "group_ec2full_attach" {
  group      = aws_iam_group.devops.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

