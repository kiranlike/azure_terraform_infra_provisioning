# TODO: Remove cms_ocpp_es_password variable when CPO production ES is migrated to terraform
variable "cms_ocpp_es_password" {
  type    = string
  default = ""
}

# TODO: Remove backend_es_password variable when CPO production ES is migrated to terraform
variable "backend_es_password" {
  type    = string
  default = ""
}

# TODO: Remove cleanup_es_password variable when CPO production ES is migrated to terraform
variable "cleanup_es_password" {
  type    = string
  default = ""
}

# TODO: remove this variable when we start using correct eventhub
# variable "temp_eventhub_connection_string" {
#   type = string
#   validation {
#     condition     = length(var.temp_eventhub_connection_string) > 0
#     error_message = "The temp_eventhub_connection_string must be present."
#   }
# }

# TODO: remove this variable when we start using correct cosmosdb
variable "temp_cosmosdb_connection_string" {
  type = string
  validation {
    condition     = length(var.temp_cosmosdb_connection_string) > 0
    error_message = "The temp_cosmosdb_connection_string must be present."
  }
}
