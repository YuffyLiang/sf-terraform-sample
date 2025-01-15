resource "snowflake_warehouse" "this" {
  name                = upper(var.warehouse_name)
  warehouse_size      = var.warehouse_size
  comment             = var.comment
  initially_suspended = true

  warehouse_type = local.warehouse_type

  provider = snowflake.sysadmin
}

resource "snowflake_execute" "this" {
  count = var.resource_monitor_name != null ? 1 : 0

  execute = "ALTER WAREHOUSE ${upper(var.warehouse_name)} SET RESOURCE_MONITOR = ${upper(var.resource_monitor_name)}"
  revert = "ALTER WAREHOUSE ${upper(var.warehouse_name)} UNSET RESOURCE_MONITOR"

  depends_on = [ snowflake_warehouse.this ]
  provider = snowflake.accountadmin
}