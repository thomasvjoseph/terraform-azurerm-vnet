resource "azurerm_virtual_network" "virtual_network" {
  name                              = var.virtual_network_name
  location                          = var.location
  resource_group_name               = var.resource_group_name
  address_space                     = var.address_space
  dns_servers                       = var.dns_servers

  dynamic "ddos_protection_plan" {
    for_each                        = var.ddos_protection_plan_id != null ? [""] : []
    content {
      id          = var.ddos_protection_plan_id
      enable      = true
    }
  }

  tags            = var.tags
}

resource "azurerm_subnet" "subnets" {
  for_each                          = var.subnets

  name                              = each.value.name
  resource_group_name               = var.resource_group_name
  virtual_network_name              = azurerm_virtual_network.virtual_network.name
  address_prefixes                  = each.value.address_prefix
  
  default_outbound_access_enabled   = !each.value.is_private
  private_endpoint_network_policies = each.value.private_endpoint_network_policies
  private_link_service_network_policies_enabled = each.value.is_private ? "false" : "true"
  service_endpoints                 = lookup(var.subnet_service_endpoints, each.value.name, [])

  dynamic "delegation" {
    for_each        = lookup(var.subnet_delegation, each.value.name, [])
    content {
      name          = delegation.value.name

      service_delegation {
        name        = delegation.value.service_delegation.name
        actions     = delegation.value.service_delegation.actions
      }
    }
  }
}
