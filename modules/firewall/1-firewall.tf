resource "digitalocean_firewall" "this" {
  name = var.name

  droplet_ids = var.droplet_ids

  dynamic "inbound_rule" {
    for_each = var.inbound_rules
    content {
      protocol         = inbound_rule.value["protocol"]
      port_range       = inbound_rule.value["protocol"] != "icmp" ? inbound_rule.value["port_range"] : null
      source_addresses = split(",", inbound_rule.value["source_addresses"])
    }
  }

  dynamic "outbound_rule" {
    for_each = var.outbound_rules
    content {
      protocol              = outbound_rule.value["protocol"]
      port_range       = outbound_rule.value["protocol"] != "icmp" ? outbound_rule.value["port_range"] : null
      destination_addresses = split(",", outbound_rule.value["destination_addresses"])
    }
  }
}