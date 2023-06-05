
# Generate Database pass and Store it into Key Vault
# Key Vault Integration Has Been Skipped

resource "random_password" "dbpass" {
  length           = 16
  special          = true
  min_special      = 5
  override_special = "!#$%&*()-_=+[]{}<>:?"

  keepers = {
    #trigger = timestamp()
    sqlserver = "sqlserver-${var.app_name}"
  }
}

resource "azurerm_mssql_server" "sqlserver" {
  name                = "sqlserver-${var.app_name}"
  resource_group_name = azurerm_resource_group.rg-infra.name
  location            = var.location
  version             = "12.0"

  administrator_login          = "sqladmin_${var.app_name}"
  administrator_login_password = random_password.dbpass.result

  tags = local.default_tags
}

resource "azurerm_mssql_database" "sqldb" {
  name         = "${var.app_name}db"
  server_id    = azurerm_mssql_server.sqlserver.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  sku_name     = var.sqldb_sku
  #max_size_gb    = 4
  #read_scale     = true
  #zone_redundant = true

  tags = local.default_tags
}

# To Access Database Privately Only From VNET, 
# We need to Create Private Endpoint
# Steps-
# 1. Create Private DNS Zone - privatelink.database.windows.net
# 2. Link this Private DNS Zone to VNET
# 3. Create Private Endpoint for Database Server

resource "azurerm_private_dns_zone" "dns-database" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.rg-infra.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns-db-vnet-link" {
  name                  = "vlink-db-${azurerm_virtual_network.vnet-infra.name}"
  resource_group_name   = azurerm_resource_group.rg-infra.name
  private_dns_zone_name = azurerm_private_dns_zone.dns-database.name
  virtual_network_id    = azurerm_virtual_network.vnet-infra.id
}

resource "azurerm_private_endpoint" "privatelink-database" {
  name                = "privatelink-${azurerm_mssql_server.sqlserver.name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-infra.name
  subnet_id           = azurerm_subnet.snet-privatelink.id

  private_dns_zone_group {
    name                 = "privatednszonegroup"
    private_dns_zone_ids = [azurerm_private_dns_zone.dns-database.id]
  }

  private_service_connection {
    name                           = "privatelink-${azurerm_mssql_server.sqlserver.name}"
    private_connection_resource_id = azurerm_mssql_server.sqlserver.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
}
