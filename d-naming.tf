data "azurecaf_name" "vnet_gw" {
  name          = var.stack
  resource_type = "azurerm_virtual_network_gateway"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug      = true
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "local_network_gateway" {
  for_each = { for c in var.vpn_connections : c.name => c }

  name          = var.stack
  resource_type = "azurerm_local_network_gateway"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, lookup(each.value, "name_suffix", "")])
  use_slug      = true
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "vpn_gw_connection" {
  for_each = { for c in var.vpn_connections : c.name => c }

  name          = var.stack
  resource_type = "azurerm_vpn_gateway_connection"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, lookup(each.value, "name_suffix", "")])
  use_slug      = true
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "gw_pub_ip" {
  name          = var.stack
  resource_type = "azurerm_public_ip"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug      = true
  clean_input   = true
  separator     = "-"
}
