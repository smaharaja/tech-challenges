
resource "azurerm_windows_web_app" "apiservice" {
  name                = "api-${var.environment}-${var.app_name}"
  resource_group_name = azurerm_resource_group.rg-infra.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.plan-web.id

  https_only = true
  tags       = local.default_tags

  #Added For Virtual Network Integration
  virtual_network_subnet_id = azurerm_subnet.snet-app.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    http2_enabled          = true
    use_32_bit_worker      = false
    vnet_route_all_enabled = true

    application_stack {
      dotnet_version = "v6.0"
    }
  }
}

# To Connect to This API Service Privately Only From VNET, 
# We need to disable Public Access and Create Private Endpoint
# Steps-
# 1. Create Private DNS Zone - privatelink.azurewebsites.net
# 2. Link this Private DNS Zone to VNET
# 3. Create Private Endpoint for API Service

resource "azurerm_private_dns_zone" "dns-websites" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.rg-infra.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns-vnet-link" {
  name                  = "vlink-${azurerm_virtual_network.vnet-infra.name}"
  resource_group_name   = azurerm_resource_group.rg-infra.name
  private_dns_zone_name = azurerm_private_dns_zone.dns-websites.name
  virtual_network_id    = azurerm_virtual_network.vnet-infra.id
}

resource "azurerm_private_endpoint" "privatelink-apiservice" {
  name                = "privatelink-${azurerm_windows_web_app.apiservice.name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-infra.name
  subnet_id           = azurerm_subnet.snet-privatelink.id

  private_dns_zone_group {
    name                 = "privatednszonegroup"
    private_dns_zone_ids = [azurerm_private_dns_zone.dns-websites.id]
  }

  private_service_connection {
    name                           = "privatelink-${azurerm_windows_web_app.apiservice.name}"
    private_connection_resource_id = azurerm_windows_web_app.apiservice.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
}
