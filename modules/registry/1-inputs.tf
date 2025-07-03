variable "name" {
  description = "The name of the registry"
  type        = string
}

variable "subscription_tier_slug" {
  description = "The slug of the subscription tier"
  type        = string
  default     = "starter"
}

variable "region" {
  description = "The region of the registry"
  type        = string
  default     = "fra1"
}