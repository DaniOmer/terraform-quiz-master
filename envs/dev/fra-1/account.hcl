locals {
  do_account_id = get_env("DO_ACCOUNT_ID_DEV", "")
  do_profile    = get_env("DO_PROFILE_DEV", "default")
  do_token      = get_env("DO_PAT_DEV", "")
}