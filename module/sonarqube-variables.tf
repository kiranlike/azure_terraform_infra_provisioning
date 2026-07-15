variable "create_sonarqube_setup" {
  type    = bool
  default = false
}

variable "kube_sonarqube_namespace" {
  type    = string
  default = "sonarqube"
}
