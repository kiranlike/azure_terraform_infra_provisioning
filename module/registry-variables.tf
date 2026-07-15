variable "create_container_registry" {
  type    = bool
  default = false
}

variable "container_registry_name" {
  type    = string
  default = "registry"
  validation {
    condition     = length(var.container_registry_name) > 0
    error_message = "Container registry name cannot be empty"
  }
}

variable "container_registry_sku" {
  type    = string
  default = "Standard"
  validation {
    condition     = length(var.container_registry_sku) > 0
    error_message = "Container registry SKU cannot be empty"
  }
}
