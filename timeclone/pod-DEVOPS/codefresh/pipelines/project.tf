
resource "codefresh_project" "project_mytutorial1" {
  name = "MyTutorial1"
  tags = [
    "staging",
    "DEVOPS",
  ]
}


resource "codefresh_project" "project_myterraform1" {
  name = "MyTerraform1"
  tags = [
    "staging",
    "DEVOPS",
  ]
}
