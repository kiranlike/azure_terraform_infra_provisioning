resource "azurerm_private_dns_zone" "private_dns_zone" {
  count               = var.create_postgres ? 1 : 0
  name                = "private-dns-zone.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.main_resource_group.name
  tags = {
    name        = "private-dns-zone.postgres.database.azure.com"
    environment = var.environment
  }
  depends_on = [
    azurerm_subnet_network_security_group_association.postgres_nsg_association
  ]
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres_private_dns_vnet_link" {
  count                 = var.create_postgres ? 1 : 0
  name                  = "private-dns-vnet-link.com"
  resource_group_name   = azurerm_resource_group.main_resource_group.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone[0].name
  virtual_network_id    = azurerm_virtual_network.main_virtual_network.id
  tags = {
    name        = "private-dns-vnet-link.com"
    environment = var.environment
  }
  depends_on = [
    azurerm_virtual_network.main_virtual_network,
    azurerm_private_dns_zone.private_dns_zone,
  ]
}

resource "azurerm_postgresql_flexible_server" "postgres_server" {
  count                         = var.create_postgres ? 1 : 0
  name                          = "${var.environment_prefix}-${var.postgres_server_name}"
  resource_group_name           = azurerm_resource_group.main_resource_group.name
  location                      = var.resource_location
  version                       = var.postgres_version
  delegated_subnet_id           = azurerm_subnet.postgres_subnet[0].id
  private_dns_zone_id           = azurerm_private_dns_zone.private_dns_zone[0].id
  administrator_login           = var.postgres_admin_user
  administrator_password        = var.postgres_admin_password
  zone                          = null
  storage_mb                    = var.postgres_size_in_mb
  sku_name                      = var.postgres_sku_name
  backup_retention_days         = var.postgres_backup_retention_days
  geo_redundant_backup_enabled  = true
  public_network_access_enabled = false
  # high_availability {
  #   mode = var.resource_location != "jioindiawest" ? "ZoneRedundant" : "SameZone"
  # }
  lifecycle {
    ignore_changes = [
      zone,
      high_availability.0.standby_availability_zone
    ]
  }
  tags = {
    name        = "${var.environment_prefix}-${var.postgres_server_name}"
    environment = var.environment
  }
  depends_on = [
    azurerm_private_dns_zone.private_dns_zone
  ]
}
