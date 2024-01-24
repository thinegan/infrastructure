output "iam_user_name" {
  description = "The user's name"
  value       = module.this.iam_user_name
}

output "iam_user_arn" {
  description = "The ARN assigned by AWS for this user"
  value       = module.this.iam_user_arn
}

output "iam_user_groups" {
  description = "The groups assigned for this user"
  value       = aws_iam_user_group_membership.this.groups
}

output "keybase_password_decrypt_command" {
  description = "Decrypt user password command"
  value       = module.this.keybase_password_decrypt_command
}
