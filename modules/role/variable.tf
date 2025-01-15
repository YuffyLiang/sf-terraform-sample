variable "role_name" {
  type = string
}

variable "parent_role_name" {
  type = string
}

variable "schema_read" {
  type    = list(string)
  default = []
}

variable "schema_write" {
  type    = list(string)
  default = []
}

variable "database_write" {
  type    = list(string)
  default = []
}

variable "warehouse_usage" {
  type    = list(string)
  default = []
}

variable "warehouse_monitor" {
  type    = list(string)
  default = []
}

variable "account_privileges" {
  type    = list(string)
  default = []
}

variable "application_roles" {
  type    = list(string)
  default = []
}

variable "imported_privileges" {
  type    = list(string)
  default = []
}

variable "extra_database_roles" {
  type    = list(string)
  default = []
}

variable "users" {
  type    = list(string)
  default = []
}

variable "ad_group" {
  type        = bool
  description = "If this value is true, the role is created and owned by `AAD_PROVISIONER` role and we just manage grant; Otherwise we create the role on top of managing grants"
}
