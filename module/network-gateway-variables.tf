variable "create_vnet_gateway" {
  type    = bool
  default = false
}

variable "vnet_gateway_name" {
  type    = string
  default = "vnet-gateway"
  validation {
    condition     = length(var.vnet_gateway_name) > 0
    error_message = "vnet gateway name cannot be empty"
  }
}

variable "vnet_gateway_ip_name" {
  type    = string
  default = "vnet-gateway-ip"
  validation {
    condition     = length(var.vnet_gateway_ip_name) > 0
    error_message = "vnet gateway ip name cannot be empty"
  }
}

variable "vnet_gateway_type" {
  type    = string
  default = "Vpn"
  validation {
    condition     = length(var.vnet_gateway_type) > 0
    error_message = "vnet gateway type cannot be empty"
  }
}

variable "vnet_gateway_vpn_type" {
  type    = string
  default = "RouteBased"
  validation {
    condition     = length(var.vnet_gateway_vpn_type) > 0
    error_message = "vnet gateway vpn type cannot be empty"
  }
}

variable "vnet_gateway_generation" {
  type    = string
  default = "Generation2"
  validation {
    condition     = length(var.vnet_gateway_generation) > 0
    error_message = "vnet gateway generation cannot be empty"
  }
}

variable "vnet_gateway_sku" {
  type    = string
  default = "VpnGw2"
  validation {
    condition     = length(var.vnet_gateway_sku) > 0
    error_message = "vnet gateway sku cannot be empty"
  }
}

variable "vnet_gateway_ip_configuration_name" {
  type    = string
  default = "vnet-gateway-ip-config"
  validation {
    condition     = length(var.vnet_gateway_ip_configuration_name) > 0
    error_message = "vnet gateway ip configuration name cannot be empty"
  }
}

variable "vnet_gateway_root_certificate_name" {
  type    = string
  default = "JELowerEnvRootCert"
  validation {
    condition     = length(var.vnet_gateway_root_certificate_name) > 0
    error_message = "vnet gateway root certificate name cannot be empty"
  }
}

variable "vnet_gateway_root_certificate_public_cert_data" {
  type = string
  validation {
    condition     = length(var.vnet_gateway_root_certificate_public_cert_data) > 0
    error_message = "vnet gateway root certificate public cert data name cannot be empty"
  }
}

