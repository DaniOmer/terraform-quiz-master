resource "digitalocean_droplet" "this" {
  name     = var.name
  image    = var.image
  size     = var.size
  region   = var.region
  vpc_uuid = var.vpc_uid
  backups  = var.backups
  ssh_keys = [digitalocean_ssh_key.this.id]
  tags     = var.tags
}

resource "digitalocean_ssh_key" "this" {
  name       = var.ssh_key_name
  public_key = file(var.public_key_path)
}