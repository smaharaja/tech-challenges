
resource "azurerm_virtual_network" "vnet-infra" {
  name                = "vnet-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-infra.name
  address_space       = var.vnet_cidr

  tags = local.default_tags

  depends_on = [azurerm_resource_group.rg-infra]
}

resource "azurerm_subnet" "snet-web" {
  name                 = "snet-${var.environment}-web"
  resource_group_name  = azurerm_resource_group.rg-infra.name
  virtual_network_name = azurerm_virtual_network.vnet-infra.name
  address_prefixes     = var.web_subnet_cidr

  delegation {
    name = "appdelegation-${var.app_name}"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }
}

resource "azurerm_subnet" "snet-app" {
  name                 = "snet-${var.environment}-app"
  resource_group_name  = azurerm_resource_group.rg-infra.name
  virtual_network_name = azurerm_virtual_network.vnet-infra.name
  address_prefixes     = var.app_subnet_cidr

  delegation {
    name = "apidelegation-${var.app_name}"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }
}

# Private Endpoint Subnet
resource "azurerm_subnet" "snet-privatelink" {
  name                 = "snet-${var.environment}-privatelink"
  resource_group_name  = azurerm_resource_group.rg-infra.name
  virtual_network_name = azurerm_virtual_network.vnet-infra.name
  address_prefixes     = var.privatelink_subnet_cidr

  private_endpoint_network_policies_enabled = true
}
