output "cosmos" {
  value = {
    # id                                = var.create_cosmos_db ? azurerm_cosmosdb_account.mongo_db[0].id : null
    endpoint                          = var.create_cosmos_db ? azurerm_cosmosdb_account.mongo_db[0].endpoint : null
    read_endpoints                    = var.create_cosmos_db ? azurerm_cosmosdb_account.mongo_db[0].read_endpoints : null
    write_endpoints                   = var.create_cosmos_db ? azurerm_cosmosdb_account.mongo_db[0].write_endpoints : null
    primary_key                       = var.create_cosmos_db ? azurerm_cosmosdb_account.mongo_db[0].primary_key : null
    secondary_key                     = var.create_cosmos_db ? azurerm_cosmosdb_account.mongo_db[0].secondary_key : null
    primary_mongodb_connection_string = var.create_cosmos_db ? azurerm_cosmosdb_account.mongo_db[0].primary_mongodb_connection_string : null
    primary_mongodb_connection_string = var.create_cosmos_db ? azurerm_cosmosdb_account.mongo_db[0].primary_mongodb_connection_string : null
  }
  sensitive = true
}
