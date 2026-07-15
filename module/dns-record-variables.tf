variable "create_operatorweb_dns_record" {
  type    = bool
  default = false
}
variable "create_consumerweb_dns_record" {
  type    = bool
  default = false
}
variable "kube_dns_prefix" {
  type = string
}

# variable "create_backend_dns_record" {
#   type    = bool
#   default = false
# }
# variable "backend_dns_prefix" {
#   type = string
# }
variable "dns_zone_name" {
  type = string
  validation {
    condition     = length(var.dns_zone_name) > 0
    error_message = "dns_zone_name cannot be empty"
  }
}

variable "dns_resource_group_name" {
  type = string
  validation {
    condition     = length(var.dns_resource_group_name) > 0
    error_message = "dns_resource_group_name cannot be empty"
  }
}

variable "operatorweb_dns_prefix" {
  type = string
}
variable "consumerweb_dns_prefix" {
  type = string
}
variable "create_kube_dns_record" {
  type    = bool
  default = false
}

variable "create_es_dns_record" {
  type    = bool
  default = false
}
variable "create_kibana_dns_record" {
  type    = bool
  default = false
}
# variable "es_dns_prefix" {
#   type = string
# }

# variable "kibana_dns_prefix" {
#   type = string
# }