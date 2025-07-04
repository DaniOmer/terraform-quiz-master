include {
  path = find_in_parent_folders("root.hcl")
}

locals {
  # Load Account level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  do_profile   = local.account_vars.locals.do_profile
  do_token     = local.account_vars.locals.do_token

  # Load Region level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  do_region   = local.region_vars.locals.do_region

  # Load Environment level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  do_environment   = local.environment_vars.locals.environment
}

terraform {
  source = "../../../../modules/project"
}

inputs = {
  name        = "quiz-master-${local.do_environment}"
  description = "A project to represent Quiz Master production resources."
  purpose     = "Web Application"
  environment = "production"
}