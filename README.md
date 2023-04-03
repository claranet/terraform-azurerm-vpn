# Azure VPN Gateway
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/vpn/azurerm/)

This feature creates an [Azure VPN Gateway](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways)
with its own dedicated Subnet, public IP, and the connections resources.

Gateway SKU list description is available on [Microsoft documentation](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways).

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 7.x.x       | 1.3.x             | >= 3.0          |
| >= 6.x.x       | 1.x               | >= 3.0          |
| >= 5.x.x       | 0.15.x            | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "azure_network_vnet" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  environment    = var.environment
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name
  vnet_cidr           = ["10.10.1.0/16"]
}

module "logs" {
  source  = "claranet/run/azurerm//modules/logs"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  extra_tags = {
    foo = "bar"
  }
}

module "vpn_gw" {
  source  = "claranet/vpn/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name

  virtual_network_name = module.azure_network_vnet.virtual_network_name
  subnet_gateway_cidr  = "10.10.1.0/25"

  vpn_connections = [
    {
      name                         = "azure_to_claranet"
      name_suffix                  = "claranet"
      vpn_gw_custom_name           = "azure_to_claranet_vpn_connection"
      local_gw_custom_name         = "azure_to_claranet_local_gateway"
      extra_tags                   = { to = "claranet" }
      local_gateway_address        = "89.185.1.1"
      local_gateway_address_spaces = ["89.185.1.1/32"]
    }
  ]

  logs_destinations_ids = [
    module.logs.log_analytics_workspace_id,
    module.logs.logs_storage_account_id
  ]

  extra_tags = {
    foo = "bar"
  }
}
```

## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.2, >= 1.2.22 |
| azurerm | ~> 3.22 |
| random | ~> 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| diagnostics | claranet/diagnostic-settings/azurerm | ~> 6.3.0 |
| subnet\_gateway | claranet/subnet/azurerm | 6.1.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_local_network_gateway.local_network_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/local_network_gateway) | resource |
| [azurerm_public_ip.virtual_gateway_pubip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_virtual_network_gateway.public_virtual_network_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway) | resource |
| [azurerm_virtual_network_gateway_connection.virtual_network_gateway_connection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway_connection) | resource |
| [random_password.vpn_ipsec_shared_key](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurecaf_name.gw_pub_ip](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.local_network_gateway](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.vnet_gw](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.vpn_gw_connection](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_routes\_to\_advertise | Additional routes reserved for this virtual network in CIDR notation. | `list(string)` | `null` | no |
| client\_name | Client name/account used in naming. | `string` | n/a | yes |
| custom\_diagnostic\_settings\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| custom\_name | Custom VPN Gateway name, generated if not set | `string` | `""` | no |
| default\_tags\_enabled | Option to enable or disable default tags | `bool` | `true` | no |
| environment | Project environment. | `string` | n/a | yes |
| extra\_tags | Additional tags to associate with your VPN Gateway | `map(string)` | `{}` | no |
| location | Azure region to use. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br>If you want to specify an Azure EventHub to send logs and metrics to, you need to provide a formated string with both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the `|` character. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| logs\_retention\_days | Number of days to keep logs on storage account. | `number` | `30` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name | `string` | `""` | no |
| network\_resource\_group\_name | VNet and Subnet Resource group name. To use only if you need to have a dedicated Resource Group for all VPN GW resources. (set via `resource_group_name` variable.) | `string` | `""` | no |
| resource\_group\_name | Name of the resource group. | `string` | n/a | yes |
| stack | Project stack name. | `string` | n/a | yes |
| subnet\_gateway\_cidr | CIDR range for the dedicated Gateway subnet. Must be a range available in the VNet. | `string` | `null` | no |
| subnet\_id | Subnet Gateway ID to use if already existing. Must be named `GatewaySubnet`. | `string` | `null` | no |
| use\_caf\_naming | Use the Azure CAF naming provider to generate default resource name. `custom_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| virtual\_network\_name | Virtual Network Name where the dedicated VPN Subnet and GW will be created. | `string` | n/a | yes |
| vpn\_client\_configuration | VPN client configuration authorizations. | <pre>object({<br>    address_space               = list(string)     # The address space out of which IP addresses for vpn clients will be taken<br>    aad_tenant                  = optional(string) # AzureAD Tenant URL<br>    aad_audience                = optional(string) # The client id of the Azure VPN application<br>    aad_issuer                  = optional(string) # The STS url for your tenant<br>    root_certificate_enabled    = optional(bool)<br>    revoked_certificate_enabled = optional(bool)<br>    root_certificate            = optional(map(string))<br>    revoked_certificate         = optional(map(string))<br>    radius_server_address       = optional(string)<br>    radius_server_secret        = optional(string)<br>    vpn_auth_types              = optional(list(string), ["AAD"])<br>    vpn_client_protocols        = optional(list(string), ["OpenVPN"])<br>  })</pre> | `null` | no |
| vpn\_connections | List of VPN Connection configurations. | <pre>list(object({<br>    name       = string<br>    extra_tags = optional(map(string))<br><br>    name_suffix          = optional(string)<br>    local_gw_custom_name = optional(string) # Generated if not set<br>    vpn_gw_custom_name   = optional(string) # Generated if not set<br><br>    local_gateway_address          = optional(string)<br>    local_gateway_fqdn             = optional(string)<br>    local_gateway_address_spaces   = optional(list(string), []) # CIDR Format<br>    local_azure_ip_address_enabled = optional(bool, false)<br><br>    shared_key = optional(string) # Generated if not set<br><br>    connection_mode     = optional(string, "Default")<br>    connection_protocol = optional(string, "IKEv2")<br>    dpd_timeout_seconds = optional(number, 45)<br><br>    enable_bgp = optional(bool, false)<br>    custom_bgp_addresses = optional(object({<br>      primary   = string<br>      secondary = string<br>    }))<br><br>    use_policy_based_traffic_selectors = optional(bool, false)<br>    traffic_selector_policy = optional(list(object({<br>      local_address_cidrs  = list(string)<br>      remote_address_cidrs = list(string)<br>    })), [])<br><br>    egress_nat_rule_ids  = optional(list(string))<br>    ingress_nat_rule_ids = optional(list(string))<br><br>    ipsec_policy = optional(object({<br>      dh_group         = string<br>      ike_encryption   = string<br>      ike_integrity    = string<br>      ipsec_encryption = string<br>      ipsec_integrity  = string<br>      pfs_group        = string<br><br>      sa_datasize = optional(number)<br>      sa_lifetime = optional(number)<br>    }))<br>  }))</pre> | `[]` | no |
| vpn\_gw\_active\_active | If true, an active-active Virtual Network Gateway will be created. An active-active gateway requires a `HighPerformance` or an `UltraPerformance` SKU. If false, an active-standby gateway will be created. | `bool` | `false` | no |
| vpn\_gw\_enable\_bgp | If true, BGP (Border Gateway Protocol) will be enabled for this Virtual Network Gateway. Defaults to false. | `bool` | `false` | no |
| vpn\_gw\_generation | Configuration of the generation of the virtual network gateway. Valid options are `Generation1`, `Generation2` or `None` | `string` | `"Generation2"` | no |
| vpn\_gw\_ipconfig\_custom\_name | VPN GW IP Config resource custom name | `string` | `""` | no |
| vpn\_gw\_public\_ip\_allocation\_method | Defines the allocation method for this IP address. Possible values are `Static` or `Dynamic`. | `string` | `"Dynamic"` | no |
| vpn\_gw\_public\_ip\_custom\_name | VPN GW Public IP resource custom name | `string` | `""` | no |
| vpn\_gw\_public\_ip\_number | Number of Public IPs to allocate and associated to the Gateway. By default only 1. Maximum is 3. | `number` | `1` | no |
| vpn\_gw\_public\_ip\_sku | The SKU of the Public IP. Accepted values are `Basic` and `Standard`. | `string` | `"Basic"` | no |
| vpn\_gw\_public\_ip\_zones | Public IP zones to configure. | `list(number)` | <pre>[<br>  1,<br>  2,<br>  3<br>]</pre> | no |
| vpn\_gw\_routing\_type | The routing type of the Virtual Network Gateway. Valid options are `RouteBased` or `PolicyBased`. Defaults to RouteBased. | `string` | `"RouteBased"` | no |
| vpn\_gw\_sku | Configuration of the size and capacity of the virtual network gateway.<br>Valid options are `Basic`, `Standard`, `HighPerformance`, `UltraPerformance`, `ErGw[1-3]AZ`, `VpnGw[1-5]`, `VpnGw[1-5]AZ`, and depend on the type and vpn\_type arguments.<br>A PolicyBased gateway only supports the Basic SKU. Further, the UltraPerformance sku is only supported by an ExpressRoute gateway.<br>SKU details and list is available at https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways. | `string` | `"VpnGw2AZ"` | no |
| vpn\_gw\_type | The type of the Virtual Network Gateway. Valid options are `Vpn` or `ExpressRoute`. Changing the type forces a new resource to be created | `string` | `"Vpn"` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpn\_connection\_ids | The VPN created connections IDs. |
| vpn\_gw\_id | Azure VPN GW ID. |
| vpn\_gw\_name | Azure VPN GW name. |
| vpn\_gw\_subnet\_id | Dedicated subnet ID for the GW. |
| vpn\_local\_gateway\_names | Azure VNET local Gateway names. |
| vpn\_local\_gw\_ids | Azure VNET local Gateway IDs. |
| vpn\_public\_ip | Azure VPN GW public IP. |
| vpn\_public\_ip\_name | Azure VPN GW public IP resource name. |
| vpn\_shared\_keys | Shared Keys used for VPN connections. |
<!-- END_TF_DOCS -->
## Specifications

* If `vpn_gw_active_active` variable is `true`, at least two public IPs will be provisionned unless more IPs are set via the `vpn_gw_public_ip_number` variable.

## Related documentation

Microsoft VPN Gateway documentation [docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways)
