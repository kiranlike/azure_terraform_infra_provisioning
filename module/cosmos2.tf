# resource "azurerm_cosmosdb_account" "mongo_db" {
#   count               = var.create_cosmos_db ? 1 : 0
#   name                = "${var.environment_prefix}-${var.cosmos_db_name}"
#   location            = var.resource_location
#   resource_group_name = azurerm_resource_group.main_resource_group.name
#   offer_type          = "Standard"
#   kind                = "MongoDB"
#   create_mode         = "Default"
#   default_identity_type = "FirstPartyIdentity"
#   analytical_storage_enabled = false
#   public_network_access_enabled     = false  # Disable public access
#   is_virtual_network_filter_enabled = true
#   virtual_network_rule {
#     ignore_missing_vnet_service_endpoint = false
#     id                                   = azurerm_subnet.cosmos_db_subnet[0].id
#   }
#   virtual_network_rule {
#     ignore_missing_vnet_service_endpoint = true
#     id                                   = azurerm_subnet.kube_subnet[0].id
#   }
#   access_key_metadata_writes_enabled = true
#   network_acl_bypass_for_azure_services = true
#   mongo_server_version                  = "6.0"
#   local_authentication_disabled         = false
#   capacity {
#     total_throughput_limit = "-1"
#   }
#   backup {
#     type = "Continuous"
#   }
#   analytical_storage {
#     schema_type = "FullFidelity"
#   }
#   capabilities {
#     name = "AllowSelfServeUpgradeToMongo36"
#   }
#   capabilities {
#     name = "EnableAggregationPipeline"
#   }
#   capabilities {
#     name = "mongoEnableDocLevelTTL"
#   }
#   capabilities {
#     name = "DisableRateLimitingResponses"
#   }
#   capabilities {
#     name = "MongoDBv3.4"
#   }
#   capabilities {
#     name = "EnableMongo"
#   }
#   consistency_policy {
#     consistency_level       = "BoundedStaleness"
#     max_interval_in_seconds = 5
#     max_staleness_prefix    = 1000
#   }
#   geo_location {
#     zone_redundant    = false
#     location          = var.resource_location
#     failover_priority = 0
#   }
#   tags = {
#     name        = "${var.environment_prefix}-${var.cosmos_db_name}"
#     environment = var.environment
#   }
# }

# resource "azurerm_private_dns_zone" "cosmos_db_private_dns_zone" {
#   count               = var.create_cosmos_db ? 1 : 0
#   name                = "privatelink.mongo.cosmos.azure.com"  # Updated for MongoDB API
#   resource_group_name = azurerm_resource_group.main_resource_group.name
#   tags = {
#     name        = "privatelink.mongo.cosmos.azure.com"
#     environment = var.environment
#   }
# }

# resource "azurerm_private_dns_zone_virtual_network_link" "cosmos_private_dns_vnet_link" {
#   count                 = var.create_cosmos_db ? 1 : 0
#   name                  = "private-dns-vnet-link.com"
#   resource_group_name   = azurerm_resource_group.main_resource_group.name
#   private_dns_zone_name = azurerm_private_dns_zone.cosmos_db_private_dns_zone[0].name
#   virtual_network_id    = azurerm_virtual_network.main_virtual_network.id
#   tags = {
#     name        = "private-dns-vnet-link.com"
#     environment = var.environment
#   }
# }

# resource "azurerm_private_endpoint" "cosmos_db_private_endpoint" {
#   count               = var.create_cosmos_db ? 1 : 0
#   name                = "${var.environment_prefix}-cosmos-db-private-endpoint"
#   location            = var.resource_location
#   resource_group_name = azurerm_resource_group.main_resource_group.name
#   subnet_id           = azurerm_subnet.cosmos_db_subnet[0].id

#   private_service_connection {
#     name                           = "${var.environment_prefix}-cosmos-db-private-connection"
#     private_connection_resource_id = azurerm_cosmosdb_account.mongo_db[0].id
#     is_manual_connection           = false
#     subresource_names              = ["MongoDB"]  # For MongoDB API
#   }

#   private_dns_zone_group {
#     name                 = "default"
#     private_dns_zone_ids = [azurerm_private_dns_zone.cosmos_db_private_dns_zone[0].id]
#   }

#   tags = {
#     name        = "${var.environment_prefix}-cosmos-db-private-endpoint"
#     environment = var.environment
#   }

#   depends_on = [
#     azurerm_cosmosdb_account.mongo_db,
#     azurerm_private_dns_zone.cosmos_db_private_dns_zone,
#   ]
# }