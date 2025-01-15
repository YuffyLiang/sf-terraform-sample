output "database_name" {
  value       = snowflake_database.this.name
  description = "The name of the Snowflake database"
}
