output "droplet_id" {
  description = "The ID of the droplet."
  value = digitalocean_droplet.this.id
}

output "droplet_name" {
  description = "The name of the Droplet."
  value = digitalocean_droplet.this.name
}

output "droplet_urn" {
  description = "The uniform resource name of the Droplet."
  value = digitalocean_droplet.this.urn
}

output "droplet_ip_address" {
  description = "The IPv4 address of the Droplet."
  value = digitalocean_droplet.this.ipv4_address
}