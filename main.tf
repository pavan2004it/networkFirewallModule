################################################################################
# Network Firewall
################################################################################

resource "aws_networkfirewall_firewall" "rp-firewall" {
  name                = var.firewall_name
  firewall_policy_arn = aws_networkfirewall_firewall_policy.rp-policy.arn
  vpc_id              = var.central_vpc_id

  subnet_mapping {
    subnet_id = var.firewall_subnet_id
  }
}

resource "aws_networkfirewall_firewall_policy" "rp-policy" {
  name = var.rule_policy_name

  firewall_policy {
    stateless_default_actions = ["aws:pass"]
    stateless_fragment_default_actions = ["aws:drop"]
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.rp_rule_group.arn
    }
  }
}

# Ensure you associate this rule group with a firewall policy and the firewall.
resource "aws_networkfirewall_rule_group" "rp_rule_group" {
  capacity = var.rule_group_capacity
  name     = var.rule_group_name
  type     = var.rule_group_type
  rule_group {
    rule_variables {
      dynamic "ip_sets"{
        for_each = var.rp_rule_group.rule_variables.ip_sets
        content {
          key = ip_sets.key
          ip_set {
            definition = ip_sets.value.definition
          }
        }
      }
      dynamic "port_sets" {
        for_each = var.rp_rule_group.rule_variables.port_sets
        content {
          key = port_sets.key
          port_set {
            definition = port_sets.value.definition
          }
        }
      }
    }
    rules_source {
      rules_string = file(var.rp_rule_group.rules_source.rules_string)
    }
  }
}

resource "aws_networkfirewall_logging_configuration" "alert_config" {
  firewall_arn = aws_networkfirewall_firewall.rp-firewall.arn
  logging_configuration {
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.firewall_alert.name
      }
      log_destination_type = var.log_destination_type
      log_type             = "ALERT"
    }
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.firewall_flow.name
      }
      log_destination_type = var.log_destination_type
      log_type             = "FLOW"
    }
  }
}

resource "aws_cloudwatch_log_group" "firewall_alert" {
  name = var.alert_log_group
}
resource "aws_cloudwatch_log_group" "firewall_flow" {
  name = var.flow_log_group
}

