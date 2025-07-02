resource "digitalocean_database_firewall" "this" {
  cluster_id = digitalocean_database_cluster.this.id

  dynamic "rule" {
    for_each = var.rules

    content {
      type  = rule.value["type"]
      value = rule.value["value"]
    }
  }
}