
resource "azurerm_windows_web_app" "webapp" {
  name                = "app-${var.environment}-${var.app_name}"
  resource_group_name = azurerm_resource_group.rg-infra.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.plan-web.id

  https_only = true
  tags       = local.default_tags

  #Added For Virtual Network Integration
  virtual_network_subnet_id = azurerm_subnet.snet-web.id

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
