variable "create_dns_manager_resources" {
  type    = bool
  default = false
}

variable "kube_devops_namespace" {
  type    = string
  default = "az-devops"
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
