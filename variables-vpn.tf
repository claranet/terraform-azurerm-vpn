# VPN GW mandatory parameters
variable "virtual_network_name" {
  description = "Virtual Network Name where the dedicated VPN subnet and Gateway will be created."
  type        = string
}

variable "network_resource_group_name" {
  description = "VNet and subnet Resource Group name. To use only if you need to have a dedicated Resource Group for all VPN Gateway resources. (set via `resource_group_name` variable.)"
  type        = string
  default     = ""
}

variable "subnet_cidr" {
  description = "CIDR range for the dedicated Gateway subnet. Must be a range available in the VNet."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Subnet Gateway ID to use if already existing. Must be named `GatewaySubnet`."
  type        = string
  default     = null
}

# VPN GW specific options

variable "public_ip_count" {
  description = "Number of Public IPs to allocate and associated to the Gateway. By default only 1. Maximum is 3."
  type        = number
  default     = 1
  validation {
    condition     = var.public_ip_count >= 1 && var.public_ip_count <= 3
    error_message = "Only one, two or three IPs can be associated to the Gateway."
  }
  validation {
    condition     = !var.active_active || (var.vpn_client_configuration == null && var.public_ip_count == 2) # ActiveActive enabled, P2S disabled, 2 IPs
    error_message = "Active active configuration requires exactly two IP Addresses."
  }
  validation {
    condition     = !var.active_active || (var.vpn_client_configuration != null && var.public_ip_count == 3)
    error_message = "Active active configuration with P2S Connections requires exactly three IP Addresses."
  }
}

variable "public_ip_allocation_method" {
  description = "Defines the allocation method for this IP address. Possible values are `Static` or `Dynamic`."
  type        = string
  default     = "Static"
}

variable "public_ip_sku" {
  description = "The SKU of the public IP. Accepted values are `Basic` and `Standard`."
  type        = string
  default     = "Standard"
}

variable "public_ip_zones" {
  description = "Public IP zones to configure."
  type        = list(number)
  default     = [1, 2, 3]
}

variable "private_ip_address_enabled" {
  description = "Whether the Virtual Network Gateway should have a private IP address. Defaults to `false`. If set to `true`, the gateway will have a private IP address."
  type        = bool
  default     = false
}

variable "type" {
  description = "The type of the Virtual Network Gateway. Valid options are `Vpn` or `ExpressRoute`. Changing the type forces a new resource to be created."
  type        = string
  default     = "Vpn"
}

variable "routing_type" {
  description = "The routing type of the Virtual Network Gateway. Valid options are `RouteBased` or `PolicyBased`. Defaults to `RouteBased`."
  type        = string
  default     = "RouteBased"
}

variable "active_active" {
  description = "If true, an active-active Virtual Network Gateway will be created. An active-active gateway requires a `HighPerformance` or an `UltraPerformance` SKU. If false, an active-standby gateway will be created."
  default     = false
  type        = bool
}

variable "gateway_generation" {
  description = "Configuration of the generation of the Virtual Network Gateway. Valid options are `Generation1`, `Generation2` or `None`."
  type        = string
  default     = "Generation2"
}

variable "sku" {
  description = <<EOD
Configuration of the size and capacity of the Virtual Network Gateway.
Valid options are `Basic`, `Standard`, `HighPerformance`, `UltraPerformance`, `ErGw[1-3]AZ`, `VpnGw[1-5]`, `VpnGw[1-5]AZ`, and depend on the `type` and `vpn_type` arguments.
A `PolicyBased` gateway only supports the `Basic` SKU. Further, the `UltraPerformance` sku is only supported by an ExpressRoute gateway.
SKU details and list is available in the [documentation](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways).
EOD
  type        = string
  default     = "VpnGw2AZ"
}

variable "bgp_enabled" {
  description = "If true, BGP (Border Gateway Protocol) will be enabled for this Virtual Network Gateway. Defaults to `false`."
  default     = false
  type        = bool
}

variable "vpn_connections" {
  description = "List of VPN connection configurations."
  type = list(object({
    name       = string
    extra_tags = optional(map(string))

    name_suffix          = optional(string)
    local_gw_custom_name = optional(string) # Generated if not set
    vpn_gw_custom_name   = optional(string) # Generated if not set

    local_gateway_address          = optional(string)
    local_gateway_fqdn             = optional(string)
    local_gateway_address_spaces   = optional(list(string), []) # CIDR Format
    local_azure_ip_address_enabled = optional(bool, false)
    local_gateway_bgp_settings = optional(object({
      asn                 = number
      bgp_peering_address = string
    }))

    shared_key = optional(string) # Generated if not set

    connection_mode     = optional(string, "Default")
    connection_protocol = optional(string, "IKEv2")
    dpd_timeout_seconds = optional(number, 45)

    enable_bgp = optional(bool, false)
    custom_bgp_addresses = optional(object({
      primary   = string
      secondary = string
    }))

    use_policy_based_traffic_selectors = optional(bool, false)
    traffic_selector_policy = optional(list(object({
      local_address_cidrs  = list(string)
      remote_address_cidrs = list(string)
    })), [])

    egress_nat_rule_names  = optional(list(string), [])
    ingress_nat_rule_names = optional(list(string), [])

    ipsec_policy = optional(object({
      dh_group         = string
      ike_encryption   = string
      ike_integrity    = string
      ipsec_encryption = string
      ipsec_integrity  = string
      pfs_group        = string

      sa_datasize = optional(number)
      sa_lifetime = optional(number)
    }))
  }))
  default = []
}

variable "vpn_client_configuration" {
  description = "VPN client configuration authorizations."
  type = object({
    address_space  = list(string)     # The address space out of which IP addresses for vpn clients will be taken
    entra_tenant   = optional(string) # Entra (aka AzureAD) Tenant URL
    entra_audience = optional(string) # The client id of the Azure VPN application
    entra_issuer   = optional(string) # The STS url for your tenant
    root_certificate = optional(list(object({
      name             = string
      public_cert_data = string
    })), [])
    revoked_certificate = optional(list(object({
      name             = string
      public_cert_data = string
    })), [])
    radius_server_address = optional(string)
    radius_server_secret  = optional(string)
    vpn_auth_types        = optional(list(string), ["AAD"])
    vpn_client_protocols  = optional(list(string), ["OpenVPN"])
  })
  default = null
}

variable "additional_routes_to_advertise" {
  description = "Additional routes reserved for this virtual network in CIDR notation."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "nat_rules" {
  description = "Map of NAT rules to apply to the VPN Gateway. For dynamic NAT rules, if `ip_configuration_name` is not set, the first IP configuration will be used."
  type = map(object({
    external_mapping = list(object({
      address_space = string
      port_range    = optional(string)
    }))
    internal_mapping = list(object({
      address_space = string
      port_range    = optional(string)
    }))
    mode                  = string
    type                  = optional(string, "Static")
    ip_configuration_name = optional(string)
    })
  )
  default  = {}
  nullable = false
  validation {
    condition     = alltrue([for rule in var.nat_rules : (rule.mode == "IngressSnat" || rule.mode == "EgressSnat")])
    error_message = "Each NAT rule must use either 'IngressSnat' or 'EgressSnat' for the mode."
  }

  validation {
    condition     = alltrue([for rule in var.nat_rules : (rule.type == "Static" || rule.type == "Dynamic")])
    error_message = "Each NAT rule must use either 'Static' or 'Dynamic' for the type."
  }
}
