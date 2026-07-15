resource "random_password" "keycloak_admin_password" {
  length = 24
}

resource "random_password" "keycloak_db_password" {
  length = 19
}

resource "kubernetes_secret" "keycloak_secret" {
  metadata {
    name      = "keycloak-secret"
    namespace = "keycloak"
  }
  type = "kubernetes.io/Opaque"
  data = {
    KEYCLOAK_ADMIN           = var.keycloak_admin_username
    KEYCLOAK_ADMIN_PASSWORD  = random_password.keycloak_admin_password.result
    KC_HOSTNAME              = "keycloak.gettruepower.net"
    KC_DB_URL_HOST           = "j7en9d-postgres.postgres.database.azure.com"
    KC_DB_URL_PORT           = "5432"
    KC_DB_USERNAME           = var.keycloak_db_username
    KC_DB_PASSWORD           = random_password.keycloak_db_password.result
    KC_DB_URL_DATABASE       = var.keycloak_db_name
    KC_HEALTH_ENABLED        = "true"
    KC_METRICS_ENABLED       = "true"
    KC_HOSTNAME_STRICT_HTTPS = "false"
    KC_HTTP_ENABLED          = "true"
    KC_PROXY                 = "edge"
    KC_HTTPS_PORT            = "8080"
    KC_DB                    = "postgres"
    KC_CACHE                 = "ispn"
    KC_CACHE_STACK           = "kubernetes"
    KC_DB_URL                = "jdbc:postgresql://j7en9d-postgres.postgres.database.azure.com:5432/${var.keycloak_db_name}"
    JAVA_OPTS_APPEND         = "-Djgroups.dns.query=keycloak.gettruepower.net"
  }
  depends_on = [
  ]
}