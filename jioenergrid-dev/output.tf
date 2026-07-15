
output "container_registry" {
  value     = module.resources.container_registry
  sensitive = true
}



output "postgres" {
  value     = module.resources.postgres
  sensitive = true
}
output "vnet_gateway" {
  value     = module.resources.vnet_gateway
  sensitive = true
}
output "cosmos" {
  value     = module.resources.cosmos
  sensitive = true
}
# output "data_storage_account_access_key" {
#   value     = module.resources.data_storage_account_access_key
#   sensitive = true
# }

# output "data_storage_account_primary_connection_string" {
#   value     = module.resources.data_storage_account_primary_connection_string
#   sensitive = true
# }

# output "backup_storage_account_access_key" {
#   value     = module.resources.backup_storage_account_access_key
#   sensitive = true
# }

# output "backup_storage_account_primary_connection_string" {
#   value     = module.resources.backup_storage_account_primary_connection_string
#   sensitive = true
# }
