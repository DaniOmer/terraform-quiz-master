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

terraform {
  source = "../../../../modules/droplet"
}

inputs = {
  name    = "quiz-master-frontend-${local.do_environment}"
  image   = "ubuntu-22-04-x64"
  size    = "s-1vcpu-1gb"
  region  = local.do_region
  vpc_uid = dependency.vpc.outputs.vpc_id
  tags    = ["quiz-master", local.do_environment, "frontend"]
  ssh_key_name = "quiz-master-frontend-${local.do_environment}"
  public_key_path = "~/.ssh/id_ed25519.pub"
}