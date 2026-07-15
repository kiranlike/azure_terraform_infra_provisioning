data "azurerm_kubernetes_service_versions" "current" {
  location        = var.resource_location
  include_preview = false
}

variable "create_aks" {
  type    = bool
  default = false
}

variable "create_aks_gpu_nodepool" {
  type    = bool
  default = false
}

variable "kube_admin_group_object_ids" {
  type = list(string)
  validation {
    condition     = length(var.kube_admin_group_object_ids) > 0
    error_message = "Admin group object IDs cannot be empty"
  }
}

variable "kube_outbound_ip_name" {
  type    = string
  default = "kube-outbound-ip"
  validation {
    condition     = length(var.kube_outbound_ip_name) > 0
    error_message = "kube outbound ip name cannot be empty"
  }
}

variable "kube_cluster_name" {
  type    = string
  default = "kube"
  validation {
    condition     = length(var.kube_cluster_name) > 0
    error_message = "Kubernetes cluster name cannot be empty"
  }
}

variable "kube_vm_size" {
  type    = string
  default = "Standard_F8s_v2"
  validation {
    condition     = length(var.kube_vm_size) > 0
    error_message = "Kubernetes VM size cannot be empty"
  }
}

variable "kube_min_node_count" {
  type    = number
  default = 3
  validation {
    condition     = var.kube_min_node_count >= 1
    error_message = "Minimum node count cannot be less than 1"
  }
}

variable "kube_max_node_count" {
  type    = number
  default = 10
  validation {
    condition     = var.kube_max_node_count >= 1
    error_message = "Maximum node count cannot be less than 1"
  }
}

variable "kube_os_disk_size_gb" {
  type    = string
  default = "50"
  validation {
    condition     = length(var.kube_os_disk_size_gb) > 0
    error_message = "Kubernetes OS disk size cannot be less than 10 GB"
  }
}

variable "kube_log_analytics_workspace_name" {
  type    = string
  default = "kube-log-analytics-workspace"
  validation {
    condition     = length(var.kube_log_analytics_workspace_name) > 0
    error_message = "Kubernetes log analytics workspace name cannot be empty"
  }
}

variable "kube_log_analytics_solution_name" {
  type    = string
  default = "ContainerInsights"
  validation {
    condition     = length(var.kube_log_analytics_solution_name) > 0
    error_message = "Kubernetes log analytics solution name cannot be empty"
  }
}

variable "kube_network_plugin" {
  type    = string
  default = "azure"
  validation {
    condition     = var.kube_network_plugin == "azure" || var.kube_network_plugin == "kubenet"
    error_message = "Kubernetes network plugin must be either azure or kubenet"
  }
}
