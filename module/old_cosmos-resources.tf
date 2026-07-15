# resource "azurerm_cosmosdb_account" "mongo_db" {
#   count               = var.create_cosmos_db ? 1 : 0
#   name                = "${var.environment_prefix}-${var.cosmos_db_name}"
#   location            = var.resource_location
#   resource_group_name = azurerm_resource_group.main_resource_group.name
#   offer_type          = "Standard"
#   kind                = "MongoDB"
#   # automatic_failover_enabled    = true
#   # minimal_tls_version           = "Tls12"
#   create_mode           = "Default"
#   default_identity_type = "FirstPartyIdentity"
#   # free_tier_enabled             = false
#   analytical_storage_enabled = false
#   # partition_merge_enabled       = false
#   public_network_access_enabled     = true
  
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
#   mongo_server_version                  = "6.0"
#   network_acl_bypass_for_azure_services = true
#   local_authentication_disabled         = false
#   capacity {
#     total_throughput_limit = "-1"
#   }
#   backup {
#     type = "Continuous"
#     # tier = "Continuous30Days"
#   }
#   # cors_rule {}
#   # identity {}
#   # restore {}
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
#   name                = "private-dns-zone.cosmos-db.database.azure.com"
#   resource_group_name = azurerm_resource_group.main_resource_group.name
#   tags = {
#     name        = "private-dns-zone.cosmos-db.database.azure.com"
#     environment = var.environment
#   }
#   depends_on = [
#     azurerm_subnet_network_security_group_association.cosmos_db_nsg_association
#   ]
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
#   depends_on = [
#     azurerm_virtual_network.main_virtual_network,
#     azurerm_private_dns_zone.cosmos_db_private_dns_zone,
#   ]
# }
# # resource "azurerm_private_endpoint" "cosmos_db_private_endpoint" {
# #   count                         = var.create_cosmos_db ? 1 : 0
# #   name                          = var.cosmos_db_private_endpoint_name
# #   resource_group_name           = azurerm_resource_group.main_resource_group.name
# #   location                      = var.resource_location
# #   subnet_id                     = azurerm_subnet.cosmos_db_subnet[0].id
# #   custom_network_interface_name = "${var.cosmos_db_private_endpoint_name}-nic"
# #   private_dns_zone_group {
# #     name = "default"
# #     private_dns_zone_ids = [
# #       azurerm_private_dns_zone.cosmos_db_private_dns_zone[0].id
# #     ]
# #   }
# #   private_service_connection {
# #     name                           = var.cosmos_db_private_endpoint_name
# #     private_connection_resource_id = azurerm_cosmosdb_account.mongo_db[0].id
# #     is_manual_connection           = false
# #     subresource_names              = ["MongoDB"]
# #   }
# #   tags = {
# #     name        = var.cosmos_db_private_endpoint_name
# #     environment = var.environment
# #   }
# #   depends_on = [
# #     azurerm_subnet.cosmos_db_subnet,
# #     azurerm_cosmosdb_account.mongo_db
# #   ]
# # }