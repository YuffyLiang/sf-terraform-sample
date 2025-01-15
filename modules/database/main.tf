resource "snowflake_database" "this" {
  name                           = upper(var.database_name)
  comment                        = var.comment
  drop_public_schema_on_creation = true

  data_retention_time_in_days = local.data_retention_time_in_days

  provider = snowflake.sysadmin
}

module "database_write_role" {
  source = "../database-role"

  database_name      = snowflake_database.this.name
  database_role_name = "${snowflake_database.this.name}__WRITE_ROLE"

  database_grants = {
    privileges = ["USAGE", "CREATE SCHEMA"]
  }

  providers = {
    snowflake.sysadmin     = snowflake.sysadmin
    snowflake.accountadmin = snowflake.accountadmin
  }
}
