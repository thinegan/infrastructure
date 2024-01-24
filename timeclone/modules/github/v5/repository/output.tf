output "name" {
  description = "Repository name"
  value       = github_repository.this.name
}

output "visibility" {
  description = "Repository visibility"
  value       = github_repository.this.visibility
}
