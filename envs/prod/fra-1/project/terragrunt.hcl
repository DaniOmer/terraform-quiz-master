terraform {
  source = "../../../../modules/project"
}

inputs = {
  name        = "quiz-master-prod"
  description = "A project to represent Quiz Master production resources."
  purpose     = "Web Application"
  environment = "Production"
}