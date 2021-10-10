# module "s3_bucket" {
#   source  = "terraform-aws-modules/s3-bucket/aws"
#   version = "1.8.0"

#   bucket = "timeclone1"
#   acl    = "private"

#   versioning = {
#     enabled = false
#   }

# }

resource "aws_s3_bucket" "bucket" {
  bucket = "my-tf-test-timeclone4"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
