variable "team_name" {
  description = "Name of github team name"
}

variable "team_description" {
  description = "Short description of the team"
}

variable "team_member" {
  description = "Add user/member to github team"
  type        = list(string)
}
