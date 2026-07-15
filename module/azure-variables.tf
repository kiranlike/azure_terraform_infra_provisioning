
data "azurerm_client_config" "current" {}

variable "azure_subscription_id" {
  type = string
  validation {
    condition     = length(var.azure_subscription_id) == 36
    error_message = "The azure_subscription_id must be 36 characters in length."
  }
}

variable "resource_location" {
  type    = string
  default = "centralindia"
  validation {
    condition     = length(var.resource_location) > 0
    error_message = "Resource location cannot be empty"
  }
}

variable "environment_prefix" {
  type = string
  validation {
    condition     = length(var.environment_prefix) > 0 && length(var.environment_prefix) <= 6
    error_message = "The environment_prefix must be at least 6 characters in length & should contain only small letters and numbers."
  }
}

variable "environment" {
  type = string
  validation {
    condition     = length(var.environment) > 0
    error_message = "Environment name cannot be empty"
  }
}
