resource "azurerm_virtual_network_gateway_nat_rule" "main" {
  for_each                   = var.nat_rules
  name                       = each.key
  resource_group_name        = var.resource_group_name
  virtual_network_gateway_id = azurerm_virtual_network_gateway.main.id
  mode                       = each.value.mode
  type                       = each.value.type

  dynamic "external_mapping" {
    for_each = each.value.external_mapping[*]
    content {
      address_space = external_mapping.value.address_space
      port_range    = external_mapping.value.port_range
    }
  }

  dynamic "internal_mapping" {
    for_each = each.value.internal_mapping[*]
    content {
      address_space = internal_mapping.value.address_space
      port_range    = internal_mapping.value.port_range
    }
  }

  lifecycle {
    precondition {
      condition     = can(regex("VpnGw[2-5](AZ)?", var.sku))
      error_message = "Nat rules are supported only on the following Gateway SKUs: VpnGw2~5, VpnGw2AZ~5AZ."
    }
  }
}
