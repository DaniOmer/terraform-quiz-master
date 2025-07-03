locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))

  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  do_profile = local.account_vars.locals.do_profile
  do_token = local.account_vars.locals.do_token
  do_region  = local.region_vars.locals.do_region
  project_name = local.common_vars.locals.project_name
}

# Configuration of the provider DigitalOcean
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = ">= 1.7.0"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  # API token is set in the environment variables
  token = "${local.do_token}"
}
EOF
}

# Configuration du backend avec DigitalOcean Spaces
remote_state {
  backend = "s3"
  config = {
    endpoint                    = "https://fra1.digitaloceanspaces.com"
    bucket                     = "${local.project_name}-terraform-state"
    key                        = "${path_relative_to_include()}/terraform.tfstate"
    region                     = "us-east-1"
    
    # Désactiver les vérifications spécifiques à AWS
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_s3_checksum            = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
} 