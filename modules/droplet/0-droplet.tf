resource "digitalocean_droplet" "this" {
  name   = var.name
  image  = var.image
  size   = var.size
  region = var.region
  vpc_uuid = var.vpc_uid
  backups = var.backups
  tags = var.tags
}