module "vpn_gw" {
  source  = "claranet/vpn/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.name

  virtual_network_name = module.vnet.name
  subnet_cidr          = "10.10.1.0/25"

  nat_rules = {
    OnPremToAzure = {
      external_mapping = [
        {
          address_space = "172.16.0.0/16"
      }]
      internal_mapping = [
        {
          address_space = "10.16.0.0/16"
      }]
      mode = "IngressSnat"
      type = "Static"

    }
  }
  vpn_connections = [
    {
      name                         = "azure_to_claranet"
      name_suffix                  = "claranet"
      custom_name                  = "azure_to_claranet_vpn_connection"
      local_gw_custom_name         = "azure_to_claranet_local_gateway"
      extra_tags                   = { to = "claranet" }
      local_gateway_address        = "89.185.1.1"
      local_gateway_address_spaces = ["89.185.1.1/32"]

      ingress_nat_rule_names = ["OnPremToAzure"]
    }
  ]

  logs_destinations_ids = [
    module.logs.id,
    module.logs.storage_account_id
  ]

  extra_tags = {
    foo = "bar"
  }
}
