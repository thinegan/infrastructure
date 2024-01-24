variable "repo_name" {
  description = "Repository name"
}

variable "repo_description" {
  description = "Repository description"
}

variable "repo_visibility" {
  description = "Visibility of the repo private/public"
  default     = "private"
}

variable "repo_team_owner" {
  description = "Team Owner id to repo"
  type = list(object({
    id         = string
    permission = string
  }))
}

variable "repo_team_permission" {
  description = "Team permission to repo"
  default     = "pull"
}
