
resource "snowflake_schema" "this" {
  name     = upper(var.schema_name)
  database = upper(var.database_name)

  data_retention_time_in_days = local.data_retention_time_in_days

  provider = snowflake.sysadmin
}

module "schema__read_role" {
  source = "../database-role"

  database_name      = upper(var.database_name)
  schema_name        = snowflake_schema.this.name
  database_role_name = "${upper(var.database_name)}__${snowflake_schema.this.name}__READ_ROLE"

  database_grants = {
    privileges = ["USAGE"]
  }

  schema_grants = [{
    schema_name = snowflake_schema.this.name
    privileges  = ["USAGE"]
  }]

  schema_objects_grants = {
    "TABLE" = [
      {
        privileges  = ["SELECT"]
        schema_name = snowflake_schema.this.name
        on_all      = true
        on_future   = true
      }
    ]
    "VIEW" = [
      {
        privileges  = ["SELECT"]
        schema_name = snowflake_schema.this.name
        on_all      = true
        on_future   = true
      }
    ]
    "DYNAMIC TABLE" = [
      {
        privileges  = ["SELECT"]
        schema_name = snowflake_schema.this.name
        on_all      = true
        on_future   = true
      }
    ]
  }

  providers = {
    snowflake.sysadmin     = snowflake.sysadmin
    snowflake.accountadmin = snowflake.accountadmin
  }
}

module "schema_write_role" {
  source = "../database-role"

  database_name      = upper(var.database_name)
  schema_name        = snowflake_schema.this.name
  database_role_name = "${upper(var.database_name)}__${snowflake_schema.this.name}__WRITE_ROLE"

  database_grants = {
    privileges = ["USAGE"]
  }

  schema_grants = [{
    schema_name = snowflake_schema.this.name
    privileges = [
      "USAGE",
      # "CREATE AUTHENTICATION POLICY",
      # "CREATE CORTEX SEARCH SERVICE",
      "CREATE DATA METRIC FUNCTION",
      "CREATE DYNAMIC TABLE",
      # "CREATE EVENT TABLE",
      # "CREATE EXTERNAL FUNCTION",
      # "CREATE EXTERNAL TABLE",
      "CREATE FILE FORMAT",
      "CREATE FUNCTION",
      # "CREATE GIT REPOSITORY",
      # "CREATE HYBRID TABLE",
      # "CREATE ICEBERG TABLE",
      # "CREATE IMAGE REPOSITORY",
      # "CREATE LISTING",
      "CREATE MASKING POLICY",
      # "CREATE MATERIALIZED VIEW",
      # "CREATE MODEL",
      # "CREATE NETWORK RULE",
      # "CREATE NOTEBOOK",
      # "CREATE PACKAGES POLICY",
      # "CREATE PASSWORD POLICY",
      # "CREATE PIPE",
      # "CREATE PRIVACY POLICY",
      # "CREATE PROCEDURE",
      # "CREATE PROJECTION POLICY",
      # "CREATE ROW ACCESS POLICY",
      # "CREATE SCHEMA ",
      # "CREATE SECRET",
      "CREATE SEQUENCE",
      # "CREATE SERVICE",
      # "CREATE SESSION POLICY",
      # "CREATE SNAPSHOT",
      "CREATE STAGE",
      "CREATE STREAM",
      "CREATE STREAMLIT",
      "CREATE TABLE",
      "CREATE TAG",
      "CREATE TASK",
      "CREATE VIEW"
    ]
  }]

  providers = {
    snowflake.sysadmin     = snowflake.sysadmin
    snowflake.accountadmin = snowflake.accountadmin
  }
}
