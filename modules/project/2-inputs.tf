variable "name" {
  type        = string
  description = "The name of the project"
}

variable "description" {
  type        = string
  description = "The description of the project"
}

variable "purpose" {
  type        = string
  description = "The purpose of the project"
}

variable "environment" {
  type        = string
  description = "The environment of the project"
}

variable "resources" {
  type        = list(string)
  description = "List of uniform resource names (URNs) for the resources associated with the project."
  default     = []
}