variable "create_pg_backup_cronjob" {
  type    = bool
  default = false
}

variable "kube_cronjobs_namespace" {
  type    = string
  default = "cronjobs"
}

variable "pg_backup_cronjob_docker_image_tag" {
  type    = string
  default = "latest"
}


variable "postgres_main_db_name" {
  type    = string
  default = "energrid_db"
}

variable "postgres_pricing_db_name" {
  type    = string
  default = "pricing_db"
}

variable "postgres_tenant_db_name" {
  type    = string
  default = "tenant_db"
}
variable "postgres_meterdata_db_name" {
  type    = string
  default = "meterdata_db"
}