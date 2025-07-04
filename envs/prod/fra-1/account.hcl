locals {
  do_profile    = get_env("DO_PROFILE_PROD", "default")
  do_token      = get_env("DO_PAT_PROD", "")
}