resource "azurerm_eventhub_namespace" "eventhub_namespace" {
  count                         = var.create_eventhub ? 1 : 0
  name                          = "${var.environment_prefix}-${var.eventhub_name}"
  location                      = var.resource_location
  resource_group_name           = azurerm_resource_group.main_resource_group.name
  sku                           = "Standard"
  capacity                      = 1
  public_network_access_enabled = true
  network_rulesets = [
    {
      public_network_access_enabled = true
      default_action                = "Deny"
      ip_rule                       = []
      virtual_network_rule = [
        {
          subnet_id                                       = azurerm_subnet.eventhub_subnet[0].id
          ignore_missing_virtual_network_service_endpoint = false
        },
        {
          subnet_id                                       = azurerm_subnet.kube_subnet[0].id
          ignore_missing_virtual_network_service_endpoint = false
        }
      ]
      trusted_service_access_enabled = true
    }
  ]
  tags = {
    name        = "${var.environment_prefix}-${var.eventhub_name}"
    environment = var.environment
  }
}

locals {
  eventhub_names = var.create_eventhub ? ["email_events", "push_events", "sms_events", "notify_events"] : []
}

resource "azurerm_eventhub" "eventhub" {
  count               = var.create_eventhub ? length(local.eventhub_names) : 0
  name                = local.eventhub_names[count.index]
  namespace_name      = azurerm_eventhub_namespace.eventhub_namespace[0].name
  resource_group_name = azurerm_resource_group.main_resource_group.name
  message_retention   = 1
  partition_count     = 2
  status              = "Active"
}

resource "azurerm_eventhub_namespace_authorization_rule" "eventhub_namespace_authorization_rule" {
  count               = var.create_eventhub ? 1 : 0
  name                = "${var.environment_prefix}-${var.eventhub_name}-auth-rule"
  namespace_name      = azurerm_eventhub_namespace.eventhub_namespace[0].name
  resource_group_name = azurerm_resource_group.main_resource_group.name
  listen              = true
  send                = true
  manage              = true
}
