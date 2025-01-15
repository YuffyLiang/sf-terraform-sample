resource "snowflake_account_role" "aad_provisioner" {
  count = local.workspace.environment == "global" ? 1 : 0

  name = "AAD_PROVISIONER"

  provider = snowflake.accountadmin
}

resource "snowflake_grant_account_role" "aad_provisioner" {
  count = local.workspace.environment == "global" ? 1 : 0

  role_name        = snowflake_account_role.aad_provisioner[0].name
  parent_role_name = "ACCOUNTADMIN"

  provider = snowflake.accountadmin
}

resource "snowflake_grant_privileges_to_account_role" "aad_provisioner" {
  count = local.workspace.environment == "global" ? 1 : 0

  account_role_name = snowflake_account_role.aad_provisioner[0].name
  privileges = [
    "CREATE USER",
    "CREATE ROLE"
  ]
  on_account = true

  provider = snowflake.accountadmin
}
