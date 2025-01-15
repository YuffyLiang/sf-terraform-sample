resource "snowflake_resource_monitor" "this" {
  name         = local.resource_monitor_name
  credit_quota = local.credit_quota
  
  frequency                 = local.frequency
  start_timestamp           = local.start_timestamp
  notify_triggers           = local.notify_triggers
  notify_users              = local.notify_users
  suspend_trigger           = local.suspend
  suspend_immediate_trigger = local.suspend_immediate

  provider = snowflake.accountadmin
}

