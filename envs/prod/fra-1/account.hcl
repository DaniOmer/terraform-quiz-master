locals {
  do_account_id = get_env("DO_ACCOUNT_ID_PROD", "")
  do_profile    = get_env("DO_PROFILE_PROD", "default")
  do_token      = get_env("DO_PAT_PROD", "")
}