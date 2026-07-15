variable "create_postgres" {
  type    = bool
  default = false
}

variable "postgres_server_name" {
  type    = string
  default = "postgres"
  validation {
    condition     = length(var.postgres_server_name) > 0
    error_message = "postgres server name cannot be empty"
  }
}

variable "postgres_version" {
  type    = number
  default = 15 // TODO: update to 16
  validation {
    condition     = var.postgres_version >= 15
    error_message = "postgres version cannot be less than 13"
  }
}

variable "postgres_admin_user" {
  type    = string
  default = "energrid_db_admin"
  validation {
    condition     = length(var.postgres_admin_user) > 0
    error_message = "postgres admin user cannot be empty"
  }
}

variable "postgres_cms_ocpp_user" {
  type    = string
  default = "cmsadmin"
  validation {
    condition     = length(var.postgres_cms_ocpp_user) > 0
    error_message = "postgres cms ocpp user cannot be empty"
  }
}

variable "postgres_papertrail_user" {
  type    = string
  default = "papertrail"
  validation {
    condition     = length(var.postgres_papertrail_user) > 0
    error_message = "postgres_papertrail_user user cannot be empty"
  }
}

variable "postgres_analytics_user" {
  type    = string
  default = "analytics"
  validation {
    condition     = length(var.postgres_analytics_user) > 0
    error_message = "postgres postgres_analytics_user cannot be empty"
  }
}

variable "postgres_sonarqube_user" {
  type    = string
  default = "sonarqubeuser"
  validation {
    condition     = length(var.postgres_sonarqube_user) > 0
    error_message = "postgres sonarqube user cannot be empty"
  }
}

variable "postgres_admin_password" {
  type = string
  validation {
    condition     = length(var.postgres_admin_password) > 8
    error_message = "postgres admin password must be at least 8 characters in length."
  }
}

# variable "postgres_cms_ocpp_password" {
#   type = string
#   validation {
#     condition     = length(var.postgres_cms_ocpp_password) > 8
#     error_message = "postgres cms ocpp password must be at least 8 characters in length."
#   }
# }

# variable "postgres_papertrail_password" {
#   type = string
#   validation {
#     condition     = length(var.postgres_papertrail_password) > 8
#     error_message = "postgres_papertrail_password password must be at least 8 characters in length."
#   }
# }

# variable "postgres_analytics_password" {
#   type = string
#   validation {
#     condition     = length(var.postgres_analytics_password) > 8
#     error_message = "postgres postgres_analytics_password must be at least 8 characters in length."
#   }
# }

variable "postgres_size_in_mb" {
  type    = number
  default = 131072
  validation {
    condition     = var.postgres_size_in_mb >= 131072
    error_message = "postgres size cannot be less than 131072"
  }
}

variable "postgres_sku_name" {
  type    = string
  default = "MO_Standard_E2s_v3"
  validation {
    condition     = length(var.postgres_sku_name) > 0
    error_message = "postgres sku name cannot be empty"
  }
}

variable "postgres_backup_retention_days" {
  type    = number
  default = 35
  validation {
    condition     = var.postgres_backup_retention_days >= 35
    error_message = "postgres backup retention days cannot be less than 35"
  }
}

variable "postgres_port" {
  type    = number
  default = 5432
}

# variable "postgres_main_db_name" {
#   type    = string
#   default = "main_db"
# }

variable "postgres_papertrail_db_name" {
  type    = string
  default = "paper_trail_db"
}

variable "postgres_cms_db_name" {
  type    = string
  default = "cms_db"
}

variable "postgres_sonarqube_db_name" {
  type    = string
  default = "sonarqubedb"
}
