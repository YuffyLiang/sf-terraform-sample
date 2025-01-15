module "resource_monitors" {
  for_each = { for resource_monitor in local.resource_monitors : resource_monitor.name => resource_monitor }

  source = "../modules/resource-monitor"

  resource_monitor_name = each.value.name
  credit_quota          = each.value.credit_quota

  frequency         = try(each.value.frequency, null)
  start_timestamp   = try(each.value.start_timestamp, null)
  notify            = try(each.value.notify, null)
  suspend           = try(each.value.suspend, null)
  suspend_immediate = try(each.value.suspend_immediate, null)
  notify_users      = try(each.value.notify_users, null)

  providers = {
    snowflake.accountadmin = snowflake.accountadmin
  }
}

module "warehouses" {
  for_each = { for warehouse in local.warehouses : warehouse.name => warehouse }

  source = "../modules/warehouse"

  warehouse_name        = each.value.name
  warehouse_size        = each.value.warehouse_size
  comment               = each.value.comment
  warehouse_type        = try(each.value.warehouse_type, null)
  resource_monitor_name = try(upper(each.value.resource_monitor), null)

  depends_on = [module.resource_monitors]

  providers = {
    snowflake.sysadmin = snowflake.sysadmin
    snowflake.accountadmin = snowflake.accountadmin
  }
}

module "databases" {
  for_each = { for database in local.databases : database.name => database }

  source = "../modules/database"

  database_name               = each.value.name
  comment                     = each.value.comment
  data_retention_time_in_days = try(each.value.data_retention_time_in_days, null)

  providers = {
    snowflake.sysadmin     = snowflake.sysadmin
    snowflake.accountadmin = snowflake.accountadmin
  }
}

module "schemas" {
  for_each = { for schema in local.database_schemas : schema.id => schema }

  source = "../modules/schema"

  database_name               = each.value.database
  schema_name                 = each.value.name
  data_retention_time_in_days = try(each.value.data_retention_time_in_days, null)

  depends_on = [module.databases]

  providers = {
    snowflake.sysadmin     = snowflake.sysadmin
    snowflake.accountadmin = snowflake.accountadmin
  }
}

module "roles" {
  for_each = { for role in local.roles : role.name => role }

  source = "../modules/role"

  role_name            = each.value.name
  parent_role_name     = lookup(each.value, "parent_role_name", null)
  schema_read          = [for schema in lookup(each.value, "schema_read", []) : upper(schema)]
  schema_write         = [for schema in lookup(each.value, "schema_write", []) : upper(schema)]
  database_write       = [for database in lookup(each.value, "database_write", []) : upper(database)]
  warehouse_usage      = [for warehouse in lookup(each.value, "warehouse_usage", []) : upper(warehouse)]
  warehouse_monitor    = [for warehouse in lookup(each.value, "warehouse_monitor", []) : upper(warehouse)]
  account_privileges   = lookup(each.value, "account_privileges", [])
  application_roles    = lookup(each.value, "application_roles", [])
  imported_privileges  = lookup(each.value, "imported_privileges", [])
  extra_database_roles = lookup(each.value, "extra_database_roles", [])
  users                = lookup(each.value, "users", [])
  ad_group             = lookup(each.value, "ad_group", null)

  depends_on = [
    snowflake_grant_privileges_to_account_role.aad_provisioner,
    module.schemas,
    module.warehouses,
  ]

  providers = {
    snowflake.sysadmin      = snowflake.sysadmin
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.accountadmin  = snowflake.accountadmin
  }
}

module "child_roles" {
  for_each = { for idx, role in local.role_parent_mapping : idx => role }

  source = "../modules/role"

  role_name            = upper(each.value.name)
  parent_role_name     = upper(each.value.parent)
  schema_read          = [for schema in each.value.schema_read : upper(schema)]
  schema_write         = [for schema in each.value.schema_write : upper(schema)]
  database_write       = [for database in each.value.database_write : upper(database)]
  warehouse_usage      = [for warehouse in each.value.warehouse_usage : upper(warehouse)]
  warehouse_monitor    = [for warehouse in each.value.warehouse_monitor : upper(warehouse)]
  account_privileges   = each.value.account_privileges
  application_roles    = each.value.application_roles
  imported_privileges  = each.value.imported_privileges
  extra_database_roles = each.value.extra_database_roles
  users                = each.value.users
  ad_group             = each.value.ad_group

  depends_on = [module.roles]

  providers = {
    snowflake.sysadmin      = snowflake.sysadmin
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.accountadmin  = snowflake.accountadmin
  }
}
