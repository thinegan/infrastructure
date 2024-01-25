# The name of the bucket
output "s3_bucket_id" {
  description = "The name of the bucket"
  value       = module.this.s3_bucket_id
}

# The ARN of the bucket
output "s3_bucket_arn" {
  description = "The ARN of the bucket"
  value       = module.this.s3_bucket_arn
}
