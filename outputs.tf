output "nw_fw"{
  value = aws_networkfirewall_firewall.rp-firewall.id
}

output "gwlb_endpoint_id" {
  description = "Gateway Load Balancer Endpoint ID for Network Firewall"
  value       = [for i in aws_networkfirewall_firewall.rp-firewall.firewall_status[0].sync_states: i.attachment[0].endpoint_id][0]
}