terraform {
  required_version = ">= 1.0.0"
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "1.0.0"
      configuration_aliases = [
        snowflake.accountadmin,
        snowflake.sysadmin,
        snowflake.securityadmin,
      ]
    }
  }
}
