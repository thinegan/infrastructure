module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "1.8.0"

  bucket = "timeclone1"
  acl    = "private"

  versioning = {
    enabled = false
  }

}