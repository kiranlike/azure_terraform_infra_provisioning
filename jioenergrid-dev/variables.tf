variable "azure_subscription_id" {
  type = string
  validation {
    condition     = length(var.azure_subscription_id) == 36
    error_message = "The azure_subscription_id must be 36 characters in length."
  }
}

variable "environment_prefix" {
  type = string
  validation {
    condition     = length(var.environment_prefix) >= 6
    error_message = "The environment_prefix must be at least 6 characters in length & should contain only small letters and numbers."
  }
}

variable "postgres_admin_password" {
  type = string
  validation {
    condition     = length(var.postgres_admin_password) >= 10
    error_message = "The postgres_admin_password must be at least 10 characters in length."
  }
}
variable "vnet_gateway_root_certificate_public_cert_data" {
  type = string
  validation {
    condition     = length(var.vnet_gateway_root_certificate_public_cert_data) >= 10
    error_message = "The vnet_gateway_root_certificate_public_cert_data must be at least 10 characters in length."
  }
}
# TODO: remove this variable when we start using correct cosmosdb
variable "temp_cosmosdb_connection_string" {
  type = string
  validation {
    condition     = length(var.temp_cosmosdb_connection_string) > 0
    error_message = "The temp_cosmosdb_connection_string must be present."
  }
}

# variable "dns_manager_auth_token" {
#   type = string
#   validation {
#     condition     = length(var.dns_manager_auth_token) >= 10
#     error_message = "The dns_manager_auth_token must be at least 10 characters in length."
#   }
# }

# variable "dns_manager_azure_client_id" {
#   type = string
#   validation {
#     condition     = length(var.dns_manager_azure_client_id) > 0
#     error_message = "The dns_manager_azure_client_id must be present."
#   }
# }

# variable "dns_manager_azure_client_secret" {
#   type = string
#   validation {
#     condition     = length(var.dns_manager_azure_client_secret) > 0
#     error_message = "The dns_manager_azure_client_secret must be present."
#   }
# }