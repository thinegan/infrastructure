output "team_name" {
  description = "team info"
  value       = github_team.this.slug
}

output "team_id" {
  description = "the team id"
  value       = github_team.this.id
}
