
resource "azurerm_service_plan" "plan-web" {
  name                = "plan-${var.environment}-web"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-infra.name

  os_type  = "Windows"
  sku_name = var.app_service_plan
  tags     = local.default_tags
}
