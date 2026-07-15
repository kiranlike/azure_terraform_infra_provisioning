variable "create_kubernetes_dashboard" {
  type    = bool
  default = false
}

variable "kube_dashboard_namespace" {
  type    = string
  default = "dashboards"
}
