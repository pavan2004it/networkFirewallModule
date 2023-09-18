variable "firewall_name" {
  type = string
}

variable "rp_rule_group" {
  type = object({
    rule_variables = object({
      ip_sets   = map(object({
        definition = list(string)
      }))
      port_sets = map(object({
        definition = list(string)
      }))
    })
    rules_source = object({
      rules_string = string
    })
  })
}

variable "rule_group_capacity" {
  type = number
}

variable "rule_group_name" {
  type = string
}

variable "rule_group_type" {
  type = string
}

variable "rule_policy_name" {
  type = string
}

variable "log_destination_type" {
  type = string
  default = "CloudWatchLogs"
}

variable "central_vpc_id" {
  type = string
}

variable "firewall_subnet_id" {
  type = string
}

variable "alert_log_group" {
  type = string
}
variable "flow_log_group" {
  type = string
}