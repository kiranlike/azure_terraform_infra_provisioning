resource "azurerm_cosmosdb_account" "mongo_db" {
  count               = var.create_cosmos_db ? 1 : 0
  name                = "${var.environment_prefix}-${var.cosmos_db_name}"
  location            = var.resource_location
  resource_group_name = azurerm_resource_group.main_resource_group.name
  offer_type          = "Standard"
  kind                = "MongoDB"
  # automatic_failover_enabled    = true
  # minimal_tls_version           = "Tls12"
  create_mode           = "Default"
  default_identity_type = "FirstPartyIdentity"
  # free_tier_enabled             = false
  analytical_storage_enabled = false
  # partition_merge_enabled       = false
  public_network_access_enabled     = false
  is_virtual_network_filter_enabled = true
  virtual_network_rule {
    ignore_missing_vnet_service_endpoint = false
    id                                   = azurerm_subnet.cosmos_db_subnet[0].id
  }
  virtual_network_rule {
    ignore_missing_vnet_service_endpoint = true
    id                                   = azurerm_subnet.kube_subnet[0].id
  }
  access_key_metadata_writes_enabled    = true
  mongo_server_version                  = "4.2"
  network_acl_bypass_for_azure_services = true
  local_authentication_disabled         = false
  capacity {
    total_throughput_limit = "-1"
  }
  backup {
    type = "Continuous"
    # tier = "Continuous30Days"
  }
  # cors_rule {}
  # identity {}
  # restore {}
  analytical_storage {
    schema_type = "FullFidelity"
  }
  capabilities {
    name = "AllowSelfServeUpgradeToMongo36"
  }
  capabilities {
    name = "EnableAggregationPipeline"
  }
  capabilities {
    name = "mongoEnableDocLevelTTL"
  }
  capabilities {
    name = "DisableRateLimitingResponses"
  }
  capabilities {
    name = "MongoDBv3.4"
  }
  capabilities {
    name = "EnableMongo"
  }
  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 1000
  }
  geo_location {
    zone_redundant    = false
    location          = var.resource_location
    failover_priority = 0
  }
  # Added IP Range Filter
  ip_range_filter = [
    # "139.167.43.8",
    # "139.167.43.10"
  ]
  tags = {
    name        = "${var.environment_prefix}-${var.cosmos_db_name}"
    environment = var.environment
  }
}
