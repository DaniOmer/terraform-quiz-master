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

dependency "database" {
  config_path = "${get_terragrunt_dir()}/../database"
  mock_outputs = {
    urn = "db-00000000000000000"
  }
}

dependency "backend-droplet" {
  config_path = "${get_terragrunt_dir()}/../backend-droplet"
  mock_outputs = {
    droplet_urn = "droplet-00000000000000000"
  }
}

dependency "frontend-droplet" {
  config_path = "${get_terragrunt_dir()}/../frontend-droplet"
  mock_outputs = {
    droplet_urn = "droplet-00000000000000000"
  }
}

terraform {
  source = "../../../../modules/project"
}

inputs = {
  name        = "quiz-master-${local.do_environment}"
  description = "A project to represent Quiz Master Development resources."
  purpose     = "Web Application"
  environment = "development"
  resources = [
    dependency.database.outputs.urn,
    dependency.backend-droplet.outputs.droplet_urn,
    dependency.frontend-droplet.outputs.droplet_urn
  ]
}