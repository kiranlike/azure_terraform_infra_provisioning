output "eventhub" {
  value = {
    # id                          = var.create_eventhub ? azurerm_eventhub_namespace.eventhub_namespace[0].id : null
    primary_key                 = var.create_eventhub ? azurerm_eventhub_namespace.eventhub_namespace[0].default_primary_key : null
    secondary_key               = var.create_eventhub ? azurerm_eventhub_namespace.eventhub_namespace[0].default_secondary_key : null
    primary_connection_string   = var.create_eventhub ? azurerm_eventhub_namespace.eventhub_namespace[0].default_primary_connection_string : null
    secondary_connection_string = var.create_eventhub ? azurerm_eventhub_namespace.eventhub_namespace[0].default_secondary_connection_string : null
  }
  sensitive = true
}
