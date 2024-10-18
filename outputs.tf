output "resource" {
  description = "VPN Gateway resource object."
  value       = azurerm_virtual_network_gateway.main
}

output "id" {
  description = "VPN Gateway ID."
  value       = azurerm_virtual_network_gateway.main.id
}

output "name" {
  description = "VPN Gateway name."
  value       = azurerm_virtual_network_gateway.main.name
}

output "resource_diagnostics" {
  description = "Diagnostics settings module outputs."
  value       = module.diagnostics
}

output "subnet_id" {
  description = "Dedicated subnet ID for the GW."
  value       = coalesce(var.subnet_id, one(module.subnet_gateway[*].id))
}

output "public_ip_name" {
  description = "Azure VPN Gateway public IP resource name."
  value       = [for pip in azurerm_public_ip.main : pip.name]
}

output "public_ip_adresses" {
  description = "Azure VPN Gateway public IPs."
  value       = [for pip in azurerm_public_ip.main : pip.ip_address]
}

output "public_ip_resources" {
  description = "Azure VPN Gateway public IPs resources."
  value       = azurerm_public_ip.main
}

output "local_gateway_names" {
  description = "Azure VNET local Gateway names."
  value       = { for k, v in azurerm_local_network_gateway.main : k => v.name }
}

output "local_gateway_ids" {
  description = "Azure VNET local Gateway IDs."
  value       = { for k, v in azurerm_local_network_gateway.main : k => v.id }
}

output "vpn_connection_ids" {
  description = "The VPN created connections IDs."
  value       = { for k, v in azurerm_virtual_network_gateway_connection.main : k => v.id }
}

output "shared_keys" {
  description = "Shared Keys used for VPN connections."
  value       = { for v in var.vpn_connections : v.name => try(random_password.main[v.name].result, v.shared_key) }
  sensitive   = true
}
