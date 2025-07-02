resource "digitalocean_vpc" "this" {
  name     = var.name
  region   = var.region
  ip_range = var.ip_range
}

resource "digitalocean_vpc_nat_gateway" "this" {
  name     = var.nat_gateway_name
  type     = var.nat_gateway_type
  size     = var.nat_gateway_size
  region   = var.region
  vpcs {
    vpc_uuid = digitalocean_vpc.this.id
  }
  udp_timeout_seconds  = var.udp_timeout_seconds
  icmp_timeout_seconds = var.icmp_timeout_seconds
  tcp_timeout_seconds  = var.tcp_timeout_seconds
}