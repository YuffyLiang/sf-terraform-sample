variable "database_name" {
  description = "Name of database"
  type        = string
}

variable "schema_name" {
  type = string
}

variable "data_retention_time_in_days" {
  type = number
}
