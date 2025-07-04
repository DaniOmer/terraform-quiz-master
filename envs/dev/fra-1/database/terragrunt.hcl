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

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../vpc"
  mock_outputs = {
    vpc_id = "vpc-00000000000000000"
  }
}

dependency "droplet" {
  config_path = "${get_terragrunt_dir()}/../backend-droplet"
  mock_outputs = {
    droplet_ip_address = "192.168.1.161"
  }
}

terraform {
  source = "../../../../modules/database"
}

inputs = {
  name                 = "quiz-master-database-${local.do_environment}"
  private_network_uuid = dependency.vpc.outputs.vpc_id
  region               = local.do_region
  rules = [
    {
      type  = "ip_addr",
      value = dependency.droplet.outputs.droplet_ip_address
    },
    {
      type  = "ip_addr",
      value = "192.168.1.161" // My Home computer IP address
    }
  ]
}