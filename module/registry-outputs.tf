output "container_registry" {
  value = {
    # id       = var.create_container_registry ? azurerm_container_registry.container_registry[0].id : null
    # name     = var.create_container_registry ? azurerm_container_registry.container_registry[0].name : null
    server   = var.create_container_registry ? azurerm_container_registry.container_registry[0].login_server : null
    username = var.create_container_registry ? azurerm_container_registry.container_registry[0].admin_username : null
    password = var.create_container_registry ? azurerm_container_registry.container_registry[0].admin_password : null
  }
  sensitive = true
}
