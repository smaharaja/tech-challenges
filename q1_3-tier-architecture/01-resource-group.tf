
resource "azurerm_resource_group" "rg-infra" {
  name     = "rg-${var.environment}-infra"
  location = var.location

  tags = local.default_tags
}
