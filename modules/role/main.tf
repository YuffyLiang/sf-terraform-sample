resource "snowflake_account_role" "this" {
  count = local.ad_group ? 0 : 1
  name  = upper(var.role_name)

  provider = snowflake.securityadmin
}

resource "snowflake_grant_account_role" "this" {
  role_name        = local.ad_group ? upper(var.role_name) : snowflake_account_role.this[0].name
  parent_role_name = local.parent_role_name

  provider = snowflake.accountadmin
}

resource "snowflake_grant_database_role" "schema_read" {
  for_each = { for schema_read_role in local.flattened_schema_read : schema_read_role.database_role => schema_read_role }

  database_role_name = each.value.database_role
  parent_role_name   = local.ad_group ? upper(var.role_name) : snowflake_account_role.this[0].name

  provider = snowflake.sysadmin
}

resource "snowflake_grant_database_role" "schema_write" {
  for_each = { for schema_write_role in local.flattened_schema_write : schema_write_role.database_role => schema_write_role }

  database_role_name = each.value.database_role
  parent_role_name   = local.ad_group ? upper(var.role_name) : snowflake_account_role.this[0].name

  provider = snowflake.sysadmin
}

resource "snowflake_grant_database_role" "database_write" {
  for_each = { for database_write_role in local.flattened_database_write : database_write_role.database_role => database_write_role }

  database_role_name = each.value.database_role
  parent_role_name   = local.ad_group ? upper(var.role_name) : snowflake_account_role.this[0].name

  provider = snowflake.sysadmin
}

resource "snowflake_grant_privileges_to_account_role" "warehouse_usage" {
  for_each = length(var.warehouse_usage) > 0 ? tomap({ for idx, value in var.warehouse_usage : idx => value }) : {}

  account_role_name = local.ad_group ? upper(var.role_name) : snowflake_account_role.this[0].name
  privileges        = ["USAGE"]

  on_account_object {
    object_type = "WAREHOUSE"
    object_name = upper(each.value)
  }

  provider = snowflake.sysadmin
}

resource "snowflake_grant_privileges_to_account_role" "warehouse_monitor" {
  for_each = length(var.warehouse_monitor) > 0 ? tomap({ for idx, value in var.warehouse_monitor : idx => value }) : {}

  account_role_name = local.ad_group ? upper(var.role_name) : snowflake_account_role.this[0].name
  privileges        = ["MONITOR"]

  on_account_object {
    object_type = "WAREHOUSE"
    object_name = upper(each.value)
  }

  provider = snowflake.sysadmin
}

resource "snowflake_grant_privileges_to_account_role" "account_privileges" {
  count = length(var.account_privileges) > 0 ? 1 : 0

  account_role_name = local.ad_group ? upper(var.role_name) : snowflake_account_role.this[0].name
  privileges        = var.account_privileges

  on_account = true

  provider = snowflake.accountadmin
}

resource "snowflake_grant_application_role" "application_role" {
  for_each = length(var.application_roles) > 0 ? tomap({ for idx, value in var.application_roles : idx => value }) : {}


  application_role_name    = each.value
  parent_account_role_name = local.ad_group ? upper(var.role_name) : snowflake_account_role.this[0].name

  provider = snowflake.accountadmin
}

resource "snowflake_grant_privileges_to_account_role" "imported_privileges" {
  for_each = length(var.imported_privileges) > 0 ? tomap({ for idx, value in var.imported_privileges : idx => value }) : {}

  account_role_name = local.ad_group ? upper(var.role_name) : snowflake_account_role.this[0].name
  privileges        = ["IMPORTED PRIVILEGES"]
  on_account_object {
    object_type = "DATABASE"
    object_name = upper(each.value)
  }

  provider = snowflake.accountadmin
}

resource "snowflake_grant_database_role" "extra_database_roles" {
  for_each = length(var.extra_database_roles) > 0 ? tomap({ for idx, value in var.extra_database_roles : idx => value }) : {}

  database_role_name = each.value
  parent_role_name   = local.ad_group ? upper(var.role_name) : snowflake_account_role.this[0].name

  provider = snowflake.accountadmin
}

resource "snowflake_grant_account_role" "grant_to_users" {
  for_each = length(var.users) > 0 ? tomap({ for idx, value in var.users : idx => value }) : {}

  role_name = local.ad_group ? upper(var.role_name) : snowflake_account_role.this[0].name
  user_name = each.value

  provider = snowflake.accountadmin
}

