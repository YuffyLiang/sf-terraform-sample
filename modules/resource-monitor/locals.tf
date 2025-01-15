locals {
  resource_monitor_name = upper(var.resource_monitor_name)

  credit_quota = var.credit_quota != null ? var.credit_quota : 50

  frequency = var.frequency != null ? var.frequency : "MONTHLY"
  start_timestamp = var.start_timestamp != null ? var.start_timestamp : "IMMEDIATELY"

  notify = var.notify != null ? var.notify : 50
  suspend = var.suspend != null ? var.suspend : 80
  suspend_immediate = var.suspend_immediate != null ? var.suspend_immediate : 95

  #  notify, suspend, suspend immediate
  notify_triggers = [local.notify, local.suspend, local.suspend_immediate]
  
  # replace with username for default
  notify_users = var.notify_users != null ? var.notify_users : ["RISHABH.SRIVASTAVA@MANTELGROUP.COM.AU"]
}
