variable "create_cosmos_db" {
  type    = bool
  default = false
}

variable "cosmos_db_name" {
  type    = string
  default = "mongo"
  validation {
    condition     = length(var.cosmos_db_name) > 0
    error_message = "cosmos DB name cannot be empty"
  }
}
variable "cosmos_db_private_endpoint_name" {
  type    = string
  default = "cosmos-db-endpoint"
  validation {
    condition     = length(var.cosmos_db_private_endpoint_name) > 0
    error_message = "cosmos_db_private_endpoint_name name cannot be empty"
  }
}
