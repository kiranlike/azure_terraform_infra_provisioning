variable "main_virtual_network_name" {
  type    = string
  default = "vnet"
  validation {
    condition     = length(var.main_virtual_network_name) > 0
    error_message = "Virtual network name cannot be empty"
  }
}

variable "main_virtual_network_address_space" {
  type    = string
  default = "10.0.0.0/8"
  validation {
    condition     = can(cidrhost(var.main_virtual_network_address_space, 0))
    error_message = "Must be valid IPv4 CIDR."
  }
}

variable "redis_subnet_name" {
  type    = string
  default = "redis-subnet"
  validation {
    condition     = length(var.redis_subnet_name) > 0
    error_message = "redis subnet name cannot be empty"
  }
}

variable "redis_subnet_address_space" {
  type    = string
  default = "10.242.0.0/16"
  validation {
    condition     = can(cidrhost(var.redis_subnet_address_space, 0))
    error_message = "Must be valid IPv4 CIDR."
  }
}

variable "eventhub_subnet_name" {
  type    = string
  default = "eventhub-subnet"
  validation {
    condition     = length(var.eventhub_subnet_name) > 0
    error_message = "eventhub subnet name cannot be empty"
  }
}

variable "eventhub_subnet_address_space" {
  type    = string
  default = "10.243.0.0/16"
  validation {
    condition     = can(cidrhost(var.eventhub_subnet_address_space, 0))
    error_message = "Must be valid IPv4 CIDR."
  }
}

variable "gateway_subnet_name" {
  type    = string
  default = "GatewaySubnet"
  validation {
    condition     = length(var.gateway_subnet_name) > 0
    error_message = "gateway subnet name cannot be empty"
  }
}

variable "gateway_subnet_address_space" {
  type    = string
  default = "10.239.0.0/16"
  validation {
    condition     = can(cidrhost(var.gateway_subnet_address_space, 0))
    error_message = "Must be valid IPv4 CIDR."
  }
}


variable "gateway_client_address_space" {
  type    = string
  default = "172.16.201.0/24"
  validation {
    condition     = can(cidrhost(var.gateway_client_address_space, 0))
    error_message = "Must be valid IPv4 CIDR."
  }
}

variable "kube_subnet_name" {
  type    = string
  default = "kube-subnet"
  validation {
    condition     = length(var.kube_subnet_name) > 0
    error_message = "Kubernetes subnet name cannot be empty"
  }
}

variable "kube_subnet_address_space" {
  type    = string
  default = "10.244.0.0/16"
  validation {
    condition     = can(cidrhost(var.kube_subnet_address_space, 0))
    error_message = "Must be valid IPv4 CIDR."
  }
}

variable "kube_services_address_space" {
  type    = string
  default = "10.0.0.0/16"
  validation {
    condition     = can(cidrhost(var.kube_services_address_space, 0))
    error_message = "Must be valid IPv4 CIDR."
  }
}

variable "kube_dns_service_ip" {
  type    = string
  default = "10.0.0.10"
  validation {
    condition     = length(var.kube_dns_service_ip) > 0
    error_message = "Must be valid IPv4 address."
  }
}

variable "postgres_subnet_name" {
  type    = string
  default = "postgres-subnet"
  validation {
    condition     = length(var.postgres_subnet_name) > 0
    error_message = "postgres subnet name cannot be empty"
  }
}

variable "postgres_subnet_address_space" {
  type    = string
  default = "10.245.0.0/16"
  validation {
    condition     = can(cidrhost(var.postgres_subnet_address_space, 0))
    error_message = "Must be valid IPv4 CIDR."
  }
}

variable "postgres_network_security_group_name" {
  type    = string
  default = "postgres-nsg"
  validation {
    condition     = length(var.postgres_network_security_group_name) > 0
    error_message = "postgres network security group name cannot be empty"
  }
}

variable "cosmos_db_subnet_name" {
  type    = string
  default = "cosmos-db-subnet"
  validation {
    condition     = length(var.cosmos_db_subnet_name) > 0
    error_message = "cosmos db subnet name cannot be empty"
  }
}

variable "cosmos_db_subnet_address_space" {
  type    = string
  default = "10.246.0.0/16"
  validation {
    condition     = can(cidrhost(var.cosmos_db_subnet_address_space, 0))
    error_message = "Must be valid IPv4 CIDR."
  }
}
variable "cosmos_db_network_security_group_name" {
  type    = string
  default = "cosmos-db-nsg"
  validation {
    condition     = length(var.cosmos_db_network_security_group_name) > 0
    error_message = "cosmos_db_network_security_group_name cannot be empty"
  }
}
# variable "public_ip_allocation_method" {
#   type    = string
#   default = "Dynamic" // TODO: Change to Static
#   validation {
#     condition     = length(var.public_ip_allocation_method) > 0
#     error_message = "public ip allocationmethod cannot be empty"
#   }
# }
