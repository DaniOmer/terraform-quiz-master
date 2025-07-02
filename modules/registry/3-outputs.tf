output "registry_id" {
  description = "The ID of the registry"
  value       = digitalocean_container_registry.this.id
}

output "registry_name" {
  description = "The name of the registry"
  value       = digitalocean_container_registry.this.name
}

output "endpoint" {
  description = "The endpoint of the registry"
  value       = digitalocean_container_registry.this.endpoint
}

output "server_url" {
  description = "The server URL of the registry"
  value       = digitalocean_container_registry.this.server_url
}