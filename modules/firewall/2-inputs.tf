variable "name" {
  description = "The name of the firewall"
  type        = string
}

variable "droplet_ids" {
  description = "List of Droplet IDs to apply the firewall to"
  type        = list(string)
}

variable "inbound_rules" {
  description = "List of inbound firewall rules"
  type = list(object({
    protocol         = string
    port_range       = optional(string)
    source_addresses = string
  }))
}

variable "outbound_rules" {
  description = "List of outbound firewall rules"
  type = list(object({
    protocol              = string
    port_range            = optional(string)
    destination_addresses = string
  }))
}