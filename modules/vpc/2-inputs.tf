variable "name" {
  description = "The name of the VPC."
  type = string
}

variable "region" {
  description = "The region where the infrastructure will be deployed."
  type = string
  default = "fra1"
}

variable "ip_range" {
  description = "The IP range of the VPC."
  type = string
  default = "10.10.10.0/24"
}