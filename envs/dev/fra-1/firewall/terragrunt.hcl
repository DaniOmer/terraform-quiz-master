include {
  path = find_in_parent_folders("root.hcl")
}


locals {
  # Load Account level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Load Region level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  do_region   = local.region_vars.locals.do_region

  # Load Environment level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  do_environment   = local.environment_vars.locals.environment
}

dependency "backend-droplet" {
  config_path = "${get_terragrunt_dir()}/../backend-droplet"
  mock_outputs = {
    droplet_id = "00000000000000000"
  }
}

dependency "frontend-droplet" {
  config_path = "${get_terragrunt_dir()}/../frontend-droplet"
  mock_outputs = {
    droplet_id = "00000000000000000"
  }
}

terraform {
  source = "../../../../modules/firewall"
}

inputs = {
  name        = "quiz-master-firewall-${local.do_environment}"
  droplet_ids = [dependency.backend-droplet.outputs.droplet_id]
  inbound_rules = [
    {
      protocol         = "tcp"
      port_range       = "80"
      source_addresses = "0.0.0.0/0" # Allow HTTP connections from everywhere
    },
    {
      protocol         = "tcp"
      port_range       = "443"
      source_addresses = "0.0.0.0/0" # Allow HTTS connections from everywhere
    },
    {
      protocol         = "tcp"
      port_range       = "22"
      source_addresses = "0.0.0.0/0" # Allow SSH connections from everywhere
    },
    {
      protocol         = "icmp"
      source_addresses = "0.0.0.0/0" # Permet le ping de partout
    }
  ]

  outbound_rules = [
    {
      protocol              = "tcp"
      port_range            = "53"
      destination_addresses = "0.0.0.0/0" # Enable DNS requests
    },
    {
      protocol              = "udp"
      port_range            = "53"
      destination_addresses = "0.0.0.0/0" # Enable DNS requests
    },
    {
      protocol              = "tcp"
      port_range            = "80"
      destination_addresses = "0.0.0.0/0" # HTTP traffic
    },
    {
      protocol              = "tcp"
      port_range            = "443"
      destination_addresses = "0.0.0.0/0" # HTTPS traffic
    },
    {
      protocol              = "tcp"
      port_range            = "25060" # For connection to database
      destination_addresses = "0.0.0.0/0"
    },
  ]
}