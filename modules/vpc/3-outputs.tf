output "vpc_id" {
  description = "The ID of the VPC."
  value = digitalocean_vpc.this.id
}

output "vpc_urn" {
  description = "The VPC uniform resource name."
  value = digitalocean_vpc.this.urn
}