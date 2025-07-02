resource "digitalocean_database_cluster" "this" {
  name                 = var.name
  engine               = var.engine
  version              = var.engine_version
  size                 = var.size
  region               = var.region
  node_count           = var.node_count
  private_network_uuid = var.private_network_uuid
  project_id           = var.project_id
}