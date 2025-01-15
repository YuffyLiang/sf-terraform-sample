locals {
  env = {
    dev = {
      environment                 = "dev"
      snowflake_organisation_name = "byjccdh"
      snowflake_account_name      = "gn79889"
      snowflake_user              = "tf-snow"

    }

    test = {
      environment                 = "test"
      snowflake_organisation_name = "byjccdh"
      snowflake_account_name      = "gn79889"
      snowflake_user              = "tf-snow"
    }

    prod = {
      environment                 = "prod"
      snowflake_organisation_name = "byjccdh"
      snowflake_account_name      = "gn79889"
      snowflake_user              = "tf-snow"
    }

    global = {
      environment                 = "global"
      snowflake_organisation_name = "byjccdh"
      snowflake_account_name      = "gn79889"
      snowflake_user              = "tf-snow"
    }
  }

  config = yamldecode(file("../config/${local.workspace.environment}.yml"))

  database_cfgs     = try(local.config["databases"], [])
  resource_monitors = try(local.config["resource_monitors"], [])
  warehouses        = try(local.config["warehouses"], [])
  roles             = try(local.config["roles"], [])

  role_parent_mapping = flatten([
    for role in local.roles : [
      for child in lookup(role, "child_roles", []) : {
        name                 = child.name
        parent               = role.name
        schema_read          = lookup(child, "schema_read", [])
        schema_write         = lookup(child, "schema_write", [])
        database_write       = lookup(child, "database_write", [])
        warehouse_usage      = lookup(child, "warehouse_usage", [])
        warehouse_monitor    = lookup(child, "warehouse_monitor", [])
        account_privileges   = lookup(child, "account_privileges", [])
        application_roles    = lookup(child, "application_roles", [])
        imported_privileges  = lookup(child, "imported_privileges", [])
        extra_database_roles = lookup(child, "extra_database_roles", [])
        users                = lookup(child, "users", [])
        ad_group             = lookup(child, "ad_group", null)
      }
    ]
  ])

  # if we do not want to create multiple identical environments,
  # use the configured databases like the following
  # databases = local.database_cfgs
  databases = flatten([
    for db in local.database_cfgs : [
      {
        name                        = db.name
        comment                     = db.comment
        data_retention_time_in_days = lookup(db, "data_retention_time_in_days", null)
        schemas                     = lookup(db, "schemas", null)
      }
    ]
  ])

  database_schemas = flatten([
    for db in local.databases : [
      for schema in lookup(db, "schemas", []) != null ? lookup(db, "schemas", []) : [] : {
        name     = schema.name
        database = db.name
        id       = "${db.name}-${schema.name}"
      }
    ]
  ])

  workspace = local.env.global

  data_classification_tags = try(local.config["data_classification_tags"], [])

  classification_roles = [
    for tag in local.data_classification_tags : {
      name   = "${tag.name}__classification_role"
      parent = "all__classification_role"
      child_roles = [
        for value in tag.values : {
          name   = "${tag.name}__${value.name}_classification_role"
          parent = "${tag.name}__classification_role"
        }
      ]
    }
  ]
}
