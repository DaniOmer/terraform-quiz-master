terraform {
  source = "../../../../modules/project"
}

inputs = {
  name        = "quiz-master-dev"
  description = "A project to represent Quiz Master development resources."
  purpose     = "Web Application"
  environment = "Development"
}