output "storage_account" {
  value = {
    data = {
      # id                          = var.create_data_storage_account ? azurerm_storage_account.data_storage_account[0].id : null
      name                 = var.create_data_storage_account ? "${var.environment_prefix}${var.data_storage_account_name}" : null
      container_name       = var.create_data_storage_account ? var.environment : null
      primary_access_key   = var.create_data_storage_account ? azurerm_storage_account.data_storage_account[0].primary_access_key : null
      secondary_access_key = var.create_data_storage_account ? azurerm_storage_account.data_storage_account[0].secondary_access_key : null
    }
    backup = {
      # id                          = var.create_backup_storage_account ? azurerm_storage_account.backup_storage_account[0].id : null
      name                 = var.create_backup_storage_account ? "${var.environment_prefix}${var.analytics_storage_account_name}" : null
      container_name       = var.create_backup_storage_account ? var.backup_storage_account_container_name : null
      primary_access_key   = var.create_backup_storage_account ? azurerm_storage_account.backup_storage_account[0].primary_access_key : null
      secondary_access_key = var.create_backup_storage_account ? azurerm_storage_account.backup_storage_account[0].secondary_access_key : null
    }
    analytics = {
      # id                          = var.create_analytics_storage_account ? azurerm_storage_account.analytics_storage_account[0].id : null
      name                 = var.create_analytics_storage_account ? "${var.environment_prefix}${var.backup_storage_account_name}" : null
      container_name       = var.create_analytics_storage_account ? var.analytics_storage_account_container_name : null
      primary_access_key   = var.create_analytics_storage_account ? azurerm_storage_account.analytics_storage_account[0].primary_access_key : null
      secondary_access_key = var.create_analytics_storage_account ? azurerm_storage_account.analytics_storage_account[0].secondary_access_key : null
    }
  }
  sensitive = true
}
