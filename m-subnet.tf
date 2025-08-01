moved {
  from = module.subnet_gateway["subnet_gw"]
  to   = module.subnet_gateway[0]
}

module "subnet_gateway" {
  source  = "claranet/subnet/azurerm"
  version = "~> 8.1.0"

  count = var.subnet_cidr != null ? 1 : 0

  environment    = var.environment
  location_short = var.location_short
  client_name    = var.client_name
  stack          = var.stack

  resource_group_name  = coalesce(var.network_resource_group_name, var.resource_group_name)
  virtual_network_name = var.virtual_network_name

  cidrs = [var.subnet_cidr]

  # Fixed name, imposed by Azure
  custom_name = "GatewaySubnet"

  # No NSG because the GW needs to generates its own rules
  network_security_group_name = null

  # No RTB because the GW needs to generates its own routes and propagate them
  route_table_name = null
}
