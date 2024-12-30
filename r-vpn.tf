moved {
  from = azurerm_public_ip.virtual_gateway_pubip
  to   = azurerm_public_ip.main
}

resource "azurerm_public_ip" "main" {
  count = local.public_ip_count

  name = try(var.public_ip_custom_names[count.index], format("%s-0%s", data.azurecaf_name.gw_pub_ip.result, count.index + 1))

  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = var.public_ip_allocation_method
  sku               = var.public_ip_sku
  zones             = var.public_ip_zones

  tags = merge(local.default_tags, var.extra_tags)

  lifecycle {
    precondition {
      condition     = length(var.public_ip_custom_names) == local.public_ip_count || length(var.public_ip_custom_names) == 0
      error_message = "You must have one public IP custom name value per public IP."
    }
  }
}

moved {
  from = azurerm_virtual_network_gateway.public_virtual_network_gateway
  to   = azurerm_virtual_network_gateway.main
}

resource "azurerm_virtual_network_gateway" "main" {
  name = local.name

  location = var.location

  # Must be in the same rg as VNET
  resource_group_name = coalesce(var.network_resource_group_name, var.resource_group_name)

  type     = var.type
  vpn_type = var.routing_type

  active_active = var.active_active
  enable_bgp    = var.bgp_enabled
  generation    = var.gateway_generation
  sku           = var.sku

  dynamic "ip_configuration" {
    for_each = [for x in range(1, local.public_ip_count + 1) : x]

    content {
      name                 = try(var.ipconfig_custom_names[ip_configuration.key], format("%s-0%s", local.vpn_gw_ipconfig_name, ip_configuration.key))
      public_ip_address_id = azurerm_public_ip.main[ip_configuration.key].id
      subnet_id            = var.subnet_cidr != null ? one(module.subnet_gateway[*].id) : var.subnet_id
    }
  }

  dynamic "custom_route" {
    for_each = length(var.additional_routes_to_advertise) > 0 ? [1] : []

    content {
      address_prefixes = var.additional_routes_to_advertise
    }
  }

  dynamic "vpn_client_configuration" {
    for_each = var.vpn_client_configuration[*]
    iterator = vpn

    content {
      address_space = vpn.value.address_space
      aad_tenant    = vpn.value.aad_tenant
      aad_audience  = vpn.value.aad_audience
      aad_issuer    = vpn.value.aad_issuer

      dynamic "root_certificate" {
        for_each = vpn.value.root_certificate
        content {
          name             = root_certificate.value.name
          public_cert_data = root_certificate.value.public_cert_data
        }
      }

      dynamic "revoked_certificate" {
        for_each = vpn.value.revoked_certificate
        content {
          name       = vpn.value.revoked_certificate.name
          thumbprint = vpn.value.revoked_certificate.public_cert_data
        }
      }

      radius_server_address = vpn.value.radius_server_address
      radius_server_secret  = vpn.value.radius_server_secret
      vpn_auth_types        = vpn.value.vpn_auth_types
      vpn_client_protocols  = vpn.value.vpn_client_protocols
    }
  }

  tags = merge(local.default_tags, var.extra_tags)

  lifecycle {
    precondition {
      condition     = length(var.ipconfig_custom_names) == local.public_ip_count || length(var.public_ip_custom_names) == 0
      error_message = "You must have one ipconfig custom name value per public IP."
    }
  }
}

moved {
  from = azurerm_local_network_gateway.local_network_gateway
  to   = azurerm_local_network_gateway.main
}

resource "azurerm_local_network_gateway" "main" {
  for_each = { for c in var.vpn_connections : c.name => c }

  name = coalesce(each.value.local_gw_custom_name, data.azurecaf_name.local_network_gateway[each.key].result)

  location            = var.location
  resource_group_name = var.resource_group_name

  gateway_address = each.value.local_gateway_address
  gateway_fqdn    = each.value.local_gateway_fqdn
  address_space   = each.value.local_gateway_address_spaces

  tags = merge(local.default_tags, var.extra_tags, each.value.extra_tags)
}

moved {
  from = azurerm_virtual_network_gateway_connection.virtual_network_gateway_connection
  to   = azurerm_virtual_network_gateway_connection.main
}

resource "azurerm_virtual_network_gateway_connection" "main" {
  for_each = { for c in var.vpn_connections : c.name => c }

  name                = coalesce(each.value.vpn_gw_custom_name, data.azurecaf_name.vpn_gw_connection[each.key].result)
  location            = var.location
  resource_group_name = var.resource_group_name

  type                           = "IPsec"
  virtual_network_gateway_id     = azurerm_virtual_network_gateway.main.id
  local_network_gateway_id       = azurerm_local_network_gateway.main[each.key].id
  local_azure_ip_address_enabled = each.value.local_azure_ip_address_enabled

  shared_key = each.value.shared_key == null ? try(random_password.main[each.key].result, null) : each.value.shared_key

  connection_mode     = each.value.connection_mode
  connection_protocol = each.value.connection_protocol
  dpd_timeout_seconds = each.value.dpd_timeout_seconds

  enable_bgp = each.value.enable_bgp

  dynamic "custom_bgp_addresses" {
    for_each = each.value.custom_bgp_addresses[*]
    content {
      primary   = each.value.custom_bgp_addresses.primary
      secondary = each.value.custom_bgp_addresses.secondary
    }
  }

  use_policy_based_traffic_selectors = each.value.use_policy_based_traffic_selectors

  dynamic "traffic_selector_policy" {
    for_each = each.value.traffic_selector_policy
    content {
      local_address_cidrs  = traffic_selector_policy.value.local_address_cidrs
      remote_address_cidrs = traffic_selector_policy.value.remote_address_cidrs
    }
  }

  tags = merge(local.default_tags, var.extra_tags, each.value.extra_tags)


  dynamic "ipsec_policy" {
    for_each = each.value.ipsec_policy[*]
    content {
      dh_group         = each.value.ipsec_policy.dh_group
      ike_encryption   = each.value.ipsec_policy.ike_encryption
      ike_integrity    = each.value.ipsec_policy.ike_integrity
      ipsec_encryption = each.value.ipsec_policy.ipsec_encryption
      ipsec_integrity  = each.value.ipsec_policy.ipsec_integrity
      pfs_group        = each.value.ipsec_policy.pfs_group

      sa_datasize = each.value.ipsec_policy.sa_datasize
      sa_lifetime = each.value.ipsec_policy.sa_lifetime
    }
  }

  egress_nat_rule_ids  = each.value.egress_nat_rule_ids
  ingress_nat_rule_ids = each.value.ingress_nat_rule_ids
}

moved {
  from = random_password.vpn_ipsec_shared_key
  to   = random_password.main
}

resource "random_password" "main" {
  for_each = { for c in var.vpn_connections : c.name => c if c.shared_key == null }
  length   = 32
  special  = false
}
