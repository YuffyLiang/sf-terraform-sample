output "warehouses" {
  value       = [for v in module.warehouses : v.warehouse_name]
  description = "the list of warehouse created"
}

output "databases" {
  value       = [for v in module.databases : v.database_name]
  description = "the list of database created"
}

output "schemas" {
  value       = [for v in module.schemas : v.schema]
  description = "the list of schemas created"
}