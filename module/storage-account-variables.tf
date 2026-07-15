variable "create_data_storage_account" {
  type    = bool
  default = false
}

variable "create_edgeiot_storage_account" {
  type    = bool
  default = false
}
variable "create_backup_storage_account" {
  type    = bool
  default = false
}

variable "create_analytics_storage_account" {
  type    = bool
  default = false
}

variable "create_adminweb_storage_account" {
  type    = bool
  default = false
}

variable "create_partnerweb_storage_account" {
  type    = bool
  default = false
}

variable "create_landingweb_storage_account" {
  type    = bool
  default = false
}

variable "create_cpoweb_storage_account" {
  type    = bool
  default = false
}

variable "create_operatorweb_storage_account" {
  type    = bool
  default = false
}
variable "create_consumerweb_storage_account" {
  type    = bool
  default = false
}


variable "create_webview_storage_account" {
  type    = bool
  default = false
}

variable "storage_account_tier" {
  type    = string
  default = "Standard"
  validation {
    condition     = length(var.storage_account_tier) > 0
    error_message = "Storage account tier cannot be empty"
  }
}

variable "storage_accunt_kind" {
  type    = string
  default = "StorageV2"
  validation {
    condition     = length(var.storage_accunt_kind) > 0
    error_message = "Storage account kind cannot be empty"
  }
}

variable "storage_account_replication_type" {
  type    = string
  default = "RAGRS"
  validation {
    condition     = length(var.storage_account_replication_type) > 0
    error_message = "storage account replication type cannot be empty"
  }

}

variable "data_storage_account_name" {
  type    = string
  default = "datastorage"
  validation {
    condition     = length(var.data_storage_account_name) > 0
    error_message = "data storage account name cannot be empty"
  }
}

variable "edgeiot_storage_account_name" {
  type    = string
  default = "edgeiotstorage"
  validation {
    condition     = length(var.edgeiot_storage_account_name) > 0
    error_message = "data storage account name cannot be empty"
  }
}

variable "backup_storage_account_name" {
  type    = string
  default = "backupstorage"
  validation {
    condition     = length(var.backup_storage_account_name) > 0
    error_message = "backup account name cannot be empty"
  }
}

variable "analytics_storage_account_name" {
  type    = string
  default = "analyticsdata"
  validation {
    condition     = length(var.analytics_storage_account_name) > 0
    error_message = "analytics account name cannot be empty"
  }
}

variable "backup_storage_account_container_name" {
  type    = string
  default = "postgres"
  validation {
    condition     = length(var.backup_storage_account_container_name) > 0
    error_message = "backup account container cannot be empty"
  }
}
variable "backup_storage_account_container_mongo_name" {
  type    = string
  default = "mongo"
  validation {
    condition     = length(var.backup_storage_account_container_mongo_name) > 0
    error_message = "backup account container cannot be empty"
  }
}

variable "analytics_storage_account_container_name" {
  type    = string
  default = "analytics"
  validation {
    condition     = length(var.analytics_storage_account_container_name) > 0
    error_message = "analytics account container cannot be empty"
  }
}

variable "landingweb_storage_account_name" {
  type    = string
  default = "landingweb"
  validation {
    condition     = length(var.landingweb_storage_account_name) > 0
    error_message = "landingweb storage account name cannot be empty"
  }
}

variable "cpoweb_storage_account_name" {
  type    = string
  default = "cpoweb"
  validation {
    condition     = length(var.cpoweb_storage_account_name) > 0
    error_message = "cpoweb account name cannot be empty"
  }
}

variable "operatorweb_storage_account_name" {
  type    = string
  default = "operatorweb"
  validation {
    condition     = length(var.operatorweb_storage_account_name) > 0
    error_message = "operatorweb account name cannot be empty"
  }
}
variable "consumerweb_storage_account_name" {
  type    = string
  default = "consumerweb"
  validation {
    condition     = length(var.consumerweb_storage_account_name) > 0
    error_message = "conumerweb account name cannot be empty"
  }
}

variable "webview_storage_account_name" {
  type    = string
  default = "webview"
  validation {
    condition     = length(var.webview_storage_account_name) > 0
    error_message = "webview account name cannot be empty"
  }
}

variable "adminweb_storage_account_name" {
  type    = string
  default = "adminweb"
  validation {
    condition     = length(var.adminweb_storage_account_name) > 0
    error_message = "admin account name cannot be empty"
  }
}

variable "partnerweb_storage_account_name" {
  type    = string
  default = "partnerweb"
  validation {
    condition     = length(var.partnerweb_storage_account_name) > 0
    error_message = "partnerweb account name cannot be empty"
  }
}
