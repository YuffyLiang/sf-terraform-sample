locals {
  flattened_schema_read = [
    for schema_read in var.schema_read : {

      database_role = join(
        "",
        [
          upper(split(".", schema_read)[0]),
          ".",
          upper(split(".", schema_read)[0]),
          "__",
          upper(replace(split(".", schema_read)[1], ".", "__")),
          "__READ_ROLE"
        ]
      )
    }
  ]
}


locals {
  flattened_schema_write = [
    for schema_write in var.schema_write : {
      database_role = join(
        "",
        [
          upper(split(".", schema_write)[0]),
          ".",
          upper(split(".", schema_write)[0]),
          "__",
          upper(replace(split(".", schema_write)[1], ".", "__")),
          "__WRITE_ROLE"
        ]
      )
    }
  ]
}

locals {
  flattened_database_write = [
    for database in var.database_write : {
      database_role = join(
        "",
        [
          upper(database),
          ".",
          upper(database),
          "__WRITE_ROLE"
        ]
      )
    }
  ]
}

locals {
  ad_group = var.ad_group != null ? var.ad_group : false
}

locals {
  parent_role_name = var.parent_role_name != null ? upper(var.parent_role_name) : "SYSADMIN"
}
