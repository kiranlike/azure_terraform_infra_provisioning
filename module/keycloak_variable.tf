variable "keycloak_admin_username" {
  description = "Keycloak username to login"
  type        = string
  default     = "admin"
}

variable "keycloak_db_name" {
  description = "Keycloak PG db name"
  type        = string
  default     = "keycloak"
}

variable "keycloak_db_username" {
  description = "Keycloak PG username"
  type        = string
  default     = "keycloak"
}