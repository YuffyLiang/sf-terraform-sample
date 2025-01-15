output "schema" {
  value       = "${snowflake_schema.this.database}.${snowflake_schema.this.name}"
  description = "the schema name and the database name of the schema."
}
