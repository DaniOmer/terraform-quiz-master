variable "name" {
  description = "The name of the VPC."
  type        = string
}

variable "region" {
  description = "The region where the infrastructure will be deployed."
  type        = string
  default     = "fra1"
}

variable "ip_range" {
  description = "The IP range of the VPC."
  type        = string
  default     = "10.10.10.0/16"
}

# variable "nat_gateway_name" {
#   description = "The name of the NAT gateway."
#   type = string
#   default = "nat-gateway"
# }

# variable "nat_gateway_type" {
#   description = "The type of the NAT gateway."
#   type = string
#   default = "PUBLIC"
# }

# variable "nat_gateway_size" {
#   description = "The size of the NAT gateway."
#   type = string
#   default = "1"
# }

# variable "udp_timeout_seconds" {
#   description = "The timeout for UDP traffic."
#   type = number
#   default = 30
# }

# variable "icmp_timeout_seconds" {
#   description = "The timeout for ICMP traffic."
#   type = number
#   default = 30
# }

# variable "tcp_timeout_seconds" {
#   description = "The timeout for TCP traffic."
#   type = number
#   default = 30
# }