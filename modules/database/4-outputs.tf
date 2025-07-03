output "id" {
  description = "The ID of the database cluster."
  value       = digitalocean_database_cluster.this.id
}

output "urn" {
  description = "The uniform resource name of the database cluster."
  value       = digitalocean_database_cluster.this.urn
}

output "host" {
  description = "Database cluster’s hostname."
  value       = digitalocean_database_cluster.this.host
}

output "port" {
  description = "Network port that the database cluster is listening on."
  value       = digitalocean_database_cluster.this.port
}

output "uri" {
  description = "The full URI for connecting to the database cluster."
  value       = digitalocean_database_cluster.this.uri
  sensitive   = true
}

output "database" {
  description = "Name of the cluster’s default database."
  value       = digitalocean_database_cluster.this.database
}

output "user" {
  description = "Username for the cluster’s default user."
  value       = digitalocean_database_cluster.this.user
  sensitive   = true
}

output "password" {
  description = "Password for the cluster’s default user."
  value       = digitalocean_database_cluster.this.password
  sensitive   = true
}