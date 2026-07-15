
resource "azurerm_storage_account" "data_storage_account" {
  count                            = var.create_data_storage_account ? 1 : 0
  name                             = "${var.environment_prefix}${var.data_storage_account_name}"
  resource_group_name              = azurerm_resource_group.main_resource_group.name
  location                         = var.resource_location
  account_tier                     = var.storage_account_tier
  account_replication_type         = var.storage_account_replication_type
  account_kind                     = var.storage_accunt_kind
  cross_tenant_replication_enabled = true
  tags = {
    name        = "${var.environment_prefix}${var.data_storage_account_name}"
    environment = var.environment
  }
  depends_on = [
    azurerm_resource_group.main_resource_group
  ]
}

resource "azurerm_storage_container" "data_storage_account_container" {
  count                 = var.create_data_storage_account ? 1 : 0
  name                  = "images"
  storage_account_name  = "${var.environment_prefix}${var.data_storage_account_name}"
  container_access_type = "private"
  depends_on = [
    azurerm_storage_account.data_storage_account
  ]
}

# resource "azurerm_storage_account" "backup_storage_account" {
#   count                            = var.create_backup_storage_account ? 1 : 0
#   name                             = "${var.environment_prefix}${var.backup_storage_account_name}"
#   resource_group_name              = azurerm_resource_group.main_resource_group.name
#   location                         = var.resource_location
#   account_tier                     = var.storage_account_tier
#   account_replication_type         = var.storage_account_replication_type
#   account_kind                     = var.storage_accunt_kind
#   cross_tenant_replication_enabled = true
#   tags = {
#     name        = "${var.environment_prefix}${var.backup_storage_account_name}"
#     environment = var.environment
#   }
#   depends_on = [
#     azurerm_resource_group.main_resource_group
#   ]
# }

# resource "azurerm_storage_container" "backup_storage_account_container" {
#   count                 = var.create_backup_storage_account ? 1 : 0
#   name                  = var.backup_storage_account_container_name
#   storage_account_name  = "${var.environment_prefix}${var.backup_storage_account_name}"
#   container_access_type = "private"
#   depends_on = [
#     azurerm_storage_account.backup_storage_account
#   ]
# }

# resource "azurerm_storage_container" "backup_storage_account_container_mongo" {
#   # count                 = var.create_backup_storage_account ? 1 : 0
#   count                 = "1"
#   name                  = "mongo"
#   storage_account_name  = "${var.environment_prefix}${var.backup_storage_account_name}"
#   container_access_type = "private"
#   depends_on = [
#     azurerm_storage_account.backup_storage_account
#   ]
# }

resource "azurerm_storage_account" "backup_storage_account" {
  count                            = var.create_backup_storage_account ? 1 : 0
  name                             = "${var.environment_prefix}${var.backup_storage_account_name}"
  resource_group_name              = azurerm_resource_group.main_resource_group.name
  location                         = var.resource_location
  account_tier                     = var.storage_account_tier
  account_replication_type         = var.storage_account_replication_type
  account_kind                     = var.storage_accunt_kind
  cross_tenant_replication_enabled = true
  allow_nested_items_to_be_public = false

  tags = {
    name        = "${var.environment_prefix}${var.backup_storage_account_name}"
    environment = var.environment
  }
  depends_on = [
    azurerm_resource_group.main_resource_group
  ]
}

resource "azurerm_storage_container" "backup_storage_account_container" {
  count                 = var.create_backup_storage_account ? 1 : 0
  name                  = var.backup_storage_account_container_name
  # storage_account_name  = "${var.environment_prefix}${var.backup_storage_account_name}"
  storage_account_id = azurerm_storage_account.backup_storage_account[0].id
  container_access_type = "private"
  depends_on = [
    azurerm_storage_account.backup_storage_account
  ]
}
resource "azurerm_storage_container" "backup_storage_account_container_mongo" {
  count                  = var.create_backup_storage_account ? 1 : 0
  name                   = var.backup_storage_account_container_mongo_name
  storage_account_id     = azurerm_storage_account.backup_storage_account[0].id
  container_access_type  = "private"
  depends_on = [
    azurerm_storage_account.backup_storage_account
  ]
}

resource "azurerm_storage_account" "analytics_storage_account" {
  count                            = var.create_analytics_storage_account ? 1 : 0
  name                             = "${var.environment_prefix}${var.analytics_storage_account_name}"
  resource_group_name              = azurerm_resource_group.main_resource_group.name
  location                         = var.resource_location
  account_tier                     = var.storage_account_tier
  account_replication_type         = var.storage_account_replication_type
  account_kind                     = var.storage_accunt_kind
  cross_tenant_replication_enabled = true
  tags = {
    name        = "${var.environment_prefix}${var.analytics_storage_account_name}"
    environment = var.environment
  }
  depends_on = [
    azurerm_resource_group.main_resource_group
  ]
}

resource "azurerm_storage_container" "analytics_storage_account_container" {
  count                 = var.create_analytics_storage_account ? 1 : 0
  name                  = var.analytics_storage_account_container_name
  storage_account_name  = "${var.environment_prefix}${var.analytics_storage_account_name}"
  container_access_type = "private"
  depends_on = [
    azurerm_storage_account.analytics_storage_account
  ]
}




resource "azurerm_storage_account" "operatorweb_storage_account" {
  count                    = var.create_operatorweb_storage_account ? 1 : 0
  name                     = "${var.environment_prefix}${var.operatorweb_storage_account_name}"
  resource_group_name      = azurerm_resource_group.main_resource_group.name
  location                 = var.resource_location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  account_kind             = var.storage_accunt_kind
  tags = {
    name        = "${var.environment_prefix}${var.operatorweb_storage_account_name}"
    environment = var.environment
  }
  static_website {
    index_document     = "index.html"
    error_404_document = "index.html"
  }
  depends_on = [
    azurerm_resource_group.main_resource_group
  ]
}


resource "azurerm_storage_account" "consumerweb_storage_account" {
  count                    = var.create_consumerweb_storage_account ? 1 : 0
  name                     = "${var.environment_prefix}${var.consumerweb_storage_account_name}"
  resource_group_name      = azurerm_resource_group.main_resource_group.name
  location                 = var.resource_location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  account_kind             = var.storage_accunt_kind
  tags = {
    name        = "${var.environment_prefix}${var.consumerweb_storage_account_name}"
    environment = var.environment
  }
  static_website {
    index_document     = "index.html"
    error_404_document = "index.html"
  }
  depends_on = [
    azurerm_resource_group.main_resource_group
  ]
}

#--------------------------------edgeiot



resource "azurerm_storage_account" "edgeiot_storage_account" {
  count                            = var.create_edgeiot_storage_account ? 1 : 0
  name                             = "${var.environment_prefix}${var.edgeiot_storage_account_name}"
  resource_group_name              = azurerm_resource_group.main_resource_group.name
  location                         = var.resource_location
  account_tier                     = var.storage_account_tier
  account_replication_type         = var.storage_account_replication_type
  account_kind                     = var.storage_accunt_kind
  cross_tenant_replication_enabled = true
  tags = {
    name        = "${var.environment_prefix}${var.edgeiot_storage_account_name}"
    environment = var.environment
  }
  depends_on = [
    azurerm_resource_group.main_resource_group
  ]
}

resource "azurerm_storage_container" "edgeiot_storage_account_container" {
  count                 = var.create_edgeiot_storage_account ? 1 : 0
  name                  = "videos"
  storage_account_name  = "${var.environment_prefix}${var.edgeiot_storage_account_name}"
  container_access_type = "container"
  depends_on = [
    azurerm_storage_account.edgeiot_storage_account
  ]
}