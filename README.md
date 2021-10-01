# Azure VPN Gateway
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/vpn/azurerm/)

This feature creates an [Azure VPN Gateway](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways) 
with its own dedicated Subnet, public IP, and the connection resource.

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 5.x.x       | 0.15.x & 1.0.x    | >= 2.0          |
| >= 4.x.x       | 0.13.x            | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

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

module "vpn_gw" {
  source  = "claranet/vpn/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name

  # You can set either a prefix for generated name or a custom one for the resource naming
  #custom_name = var.custom_vpn_gw_name

  virtual_network_name = module.azure_network_vnet.virtual_network_name
  subnet_gateway_cidr  = "10.10.1.0/25"

  on_prem_gateway_subnets_cidrs = var.on_prem_gateway_subnets
  on_prem_gateway_ip            = var.on_prem_gateway_ip

  vpn_ipsec_shared_key = var.shared_key

  vpn_gw_connection_name = "azure_to_${var.client_name}_on-prem"
}

```

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.8.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| subnet\_gateway | claranet/subnet/azurerm | 4.2.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_local_network_gateway.local_network_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/local_network_gateway) | resource |
| [azurerm_public_ip.virtual_gateway_pubip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_virtual_network_gateway.public_virtual_network_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway) | resource |
| [azurerm_virtual_network_gateway_connection.azurehub_to_onprem](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway_connection) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| custom\_name | Custom VPN Gateway name, generated if not set | `string` | `""` | no |
| environment | Project environment | `string` | n/a | yes |
| extra\_tags | Additional tags to associate with your VPN Gateway. | `map(string)` | `{}` | no |
| location | Azure region to use | `string` | n/a | yes |
| location\_short | Short string for Azure location | `string` | n/a | yes |
| name\_prefix | Optional prefix for VPN Gateway name | `string` | `""` | no |
| network\_resource\_group\_name | Vnet and subnet Resource group name. To use only if you need to have a dedicated Resource Group for all VPN GW resources. (set via `resource_group_name` var.) | `string` | `""` | no |
| on\_prem\_gateway\_ip | On-premise Gateway endpoint IP to connect Azure with. | `string` | n/a | yes |
| on\_prem\_gateway\_subnets\_cidrs | On-premise subnets list to route from the Hub. (list of strings) | `list(string)` | n/a | yes |
| resource\_group\_name | Name of the resource group | `string` | n/a | yes |
| stack | Project stack name | `string` | n/a | yes |
| subnet\_gateway\_cidr | CIDR range for the dedicated Gateway subnet. Must be a range available in the Vnet. | `string` | n/a | yes |
| virtual\_network\_name | Virtual Network Name where the dedicated Subnet and GW will be created. | `string` | n/a | yes |
| vpn\_gw\_active\_active | If true, an active-active Virtual Network Gateway will be created. An active-active gateway requires a HighPerformance or an UltraPerformance sku. If false, an active-standby gateway will be created. Defaults to false. | `bool` | `false` | no |
| vpn\_gw\_connection\_name | Custom name for VPN Gateway connection resource. | `string` | `"azure_hub_to_on-prem_resources"` | no |
| vpn\_gw\_enable\_bgp | If true, BGP (Border Gateway Protocol) will be enabled for this Virtual Network Gateway. Defaults to false. | `bool` | `false` | no |
| vpn\_gw\_ipconfig\_custom\_name | VPN GW IP Config resource custom name | `string` | `""` | no |
| vpn\_gw\_public\_ip\_allocation\_method | Defines the allocation method for this IP address. Possible values are `Static` or `Dynamic`. | `string` | `"Dynamic"` | no |
| vpn\_gw\_public\_ip\_custom\_name | VPN GW Public IP resource custom name | `string` | `""` | no |
| vpn\_gw\_public\_ip\_sku | The SKU of the Public IP. Accepted values are `Basic` and `Standard`. | `string` | `"Basic"` | no |
| vpn\_gw\_routing\_type | The routing type of the Virtual Network Gateway. Valid options are `RouteBased` or `PolicyBased`. Defaults to RouteBased. | `string` | `"RouteBased"` | no |
| vpn\_gw\_sku | Configuration of the size and capacity of the virtual network gateway. Valid options are Basic, Standard, HighPerformance, UltraPerformance, ErGw1AZ, ErGw2AZ, ErGw3AZ, VpnGw1, VpnGw2, VpnGw3, VpnGw1AZ, VpnGw2AZ, and VpnGw3AZ and depend on the type and vpn\_type arguments. A PolicyBased gateway only supports the Basic sku. Further, the UltraPerformance sku is only supported by an ExpressRoute gateway. | `string` | `"VpnGw1"` | no |
| vpn\_gw\_type | The type of the Virtual Network Gateway. Valid options are `Vpn` or `ExpressRoute`. Changing the type forces a new resource to be created | `string` | `"Vpn"` | no |
| vpn\_ipsec\_shared\_key | The Shared key between both On-premise Gateway and Azure GW for VPN IPsec connection. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| vpn\_connection\_id | The VPN connection id. |
| vpn\_gw\_id | Azure VPN GW id. |
| vpn\_gw\_name | Azure VPN GW name. |
| vpn\_gw\_subnet\_id | Dedicated subnet id for the GW. |
| vpn\_local\_gw\_id | Azure vnet local GW id. |
| vpn\_local\_gw\_name | Azure vnet local GW name. |
| vpn\_public\_ip | Azure VPN GW public IP. |
| vpn\_public\_ip\_name | Azure VPN GW public IP resource name. |
<!-- END_TF_DOCS -->
## Related documentation

Microsoft VPN Gateway documentation [docs.microsoft.com/fr-fr/azure/vpn-gateway/vpn-gateway-about-vpngateways](https://docs.microsoft.com/fr-fr/azure/vpn-gateway/vpn-gateway-about-vpngateways)
