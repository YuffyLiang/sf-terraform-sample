variable "resource_monitor_name" {
  type = string
}

variable "credit_quota" {
  type = number
}

variable "frequency" {
  type = string
}

variable "start_timestamp" {
  type = string
}

variable "notify" {
  type = number
}

variable "suspend" {
  type = number
}

variable "suspend_immediate" {
  type = number
}

variable "notify_users" {
  type = list(string)
}