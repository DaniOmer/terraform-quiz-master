variable "name" {
  description = "The name of the database cluster."
  type        = string
}

variable "engine" {
  description = "Database engine used by the cluster."
  type        = string
  default     = "pg"
}

variable "size" {
  description = "Database Droplet size associated with the cluster."
  type        = string
  default     = "db-s-1vcpu-1gb"
}

variable "engine_version" {
  description = "Engine version used by the cluster."
  type        = string
  default     = "15"
}

variable "node_count" {
  description = "Number of nodes that will be included in the cluster."
  type        = number
  default     = 1
}

variable "private_network_uuid" {
  description = "The ID of the VPC where the database cluster will be located."
  type        = string
}

variable "project_id" {
  description = "The ID of the project that the database cluster is assigned to."
  type        = string
}

variable "region" {
  description = "DigitalOcean region where the cluster will reside."
  type        = string
  default     = "fra1"
}

variable "rules" {
  description = "List of inbound database firewall rules"
  type = list(object({
    type  = string,
    value = string
  }))
}
