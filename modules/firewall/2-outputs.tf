output "firewall_id" {
  description = "The ID of the DigitalOcean firewall"
  value       = digitalocean_firewall.this.id
}
