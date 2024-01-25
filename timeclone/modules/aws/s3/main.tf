######################################################################################################
# ref : https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/3.6.0
######################################################################################################

module "this" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.6.0" # keep version control to avoid getting updated to latest version without getting tested first.

  bucket = var.name
  acl    = var.access

  # S3 Bucket Ownership Controls
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls
  control_object_ownership = true
  object_ownership         = "BucketOwnerEnforced"

  # Allow deletion of non-empty bucket
  force_destroy = true

  # Server-side encryption protects data at rest. Amazon S3 encrypts each object with a unique key. As an additional safeguard, it encrypts the key 
  # itself with a key that it rotates regularly. Amazon S3 server-side encryption uses one of the strongest block ciphers available to encrypt your data,
  # 256-bit Advanced Encryption Standard (AES-256).
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule = [
    {
      id      = join("", [var.name, "Archive"])
      enabled = true

      transition = [
        {
          days          = 90
          storage_class = "GLACIER"
        }
      ]

      expiration = {
        days                         = 180
        expired_object_delete_marker = true
      }
  }]

  tags = {
    Name        = var.name
    Environment = var.environment
    pod         = var.pod
  }
}
