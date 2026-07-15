resource "azurerm_container_registry" "container_registry" {
  count                         = var.create_container_registry ? 1 : 0
  name                          = "${var.environment_prefix}${var.container_registry_name}"
  resource_group_name           = azurerm_resource_group.main_resource_group.name
  location                      = var.resource_location
  sku                           = var.container_registry_sku
  public_network_access_enabled = true
  admin_enabled                 = true

  lifecycle {
    ignore_changes = [
      identity
    ]
  }
  tags = {
    name        = "${var.environment_prefix}${var.container_registry_name}"
    environment = var.environment
  }
  depends_on = [
    azurerm_resource_group.main_resource_group,
    azurerm_virtual_network.main_virtual_network
  ]
}
