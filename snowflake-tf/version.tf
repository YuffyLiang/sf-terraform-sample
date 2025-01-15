terraform {
  required_version = ">= 1.0.0"
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "1.0.0"
    }
  }
}

provider "snowflake" {
  alias = "accountadmin"

  organization_name = local.workspace.snowflake_organisation_name
  account_name      = local.workspace.snowflake_account_name
  user              = local.workspace.snowflake_user
  authenticator     = "SNOWFLAKE_JWT"
  private_key       = file("~/.ssh/snowflake_tf_snow_key.p8")
  role              = "accountadmin"
}

provider "snowflake" {
  alias = "sysadmin"

  organization_name = local.workspace.snowflake_organisation_name
  account_name      = local.workspace.snowflake_account_name
  user              = local.workspace.snowflake_user
  authenticator     = "SNOWFLAKE_JWT"
  private_key       = file("~/.ssh/snowflake_tf_snow_key.p8")
  role              = "sysadmin"
}

provider "snowflake" {
  alias = "securityadmin"

  organization_name = local.workspace.snowflake_organisation_name
  account_name      = local.workspace.snowflake_account_name
  user              = local.workspace.snowflake_user
  authenticator     = "SNOWFLAKE_JWT"
  private_key       = file("~/.ssh/snowflake_tf_snow_key.p8")
  role              = "securityadmin"
}
