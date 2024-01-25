######################################################################################################
# ref : https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/3.15.1
######################################################################################################

module "this" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = var.name
  acl    = var.access

  # ACLs disabled (recommended)
  # All objects in this bucket are owned by this account. 
  # Access to this bucket and its objects is specified using only policies.
  control_object_ownership = false
  # object_ownership         = "ObjectWriter"
  force_destroy = true

  # Server-side encryption protects data at rest. Amazon S3 encrypts each object with a unique key. As an additional safeguard, 
  # it encrypts the key itself with a key that it rotates regularly. Amazon S3 server-side encryption uses one of the strongest
  # block ciphers available to encrypt your data, 256-bit Advanced Encryption Standard (AES-256).
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
