resource "random_password" "postgres_sonarqube_password" {
  count   = var.create_sonarqube_setup ? 1 : 0
  length  = 25
  special = false
  lifecycle {
    ignore_changes = [special]
  }
  depends_on = []
}

resource "random_password" "sonarqube_admin_password" {
  count   = var.create_sonarqube_setup ? 1 : 0
  length  = 20
  special = false
  lifecycle {
    ignore_changes = [special]
  }
  depends_on = []
}

resource "kubernetes_namespace" "sonarqube" {
  count = var.create_sonarqube_setup ? 1 : 0
  metadata {
    annotations = {
      name = var.kube_sonarqube_namespace
    }
    labels = {
      name = var.kube_sonarqube_namespace
    }
    name = var.kube_sonarqube_namespace
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "kubernetes_secret_v1" "sonarqube_secret" {
  count = var.create_sonarqube_setup ? 1 : 0
  type  = "kubernetes.io/Opaque"
  metadata {
    name      = "sonarqube-secrets"
    namespace = var.kube_sonarqube_namespace
  }
  data = {
    SONARQUBE_ADMIN_PASSWORD = var.create_sonarqube_setup ? random_password.sonarqube_admin_password[0].result : null
    PG_USER                  = var.postgres_sonarqube_user
    PG_PASSWORD              = var.create_sonarqube_setup ? random_password.postgres_sonarqube_password[0].result : null
    PG_DB_NAME               = var.postgres_sonarqube_db_name
    PG_HOST                  = var.create_postgres ? azurerm_postgresql_flexible_server.postgres_server[0].fqdn : null
    PG_PORT                  = var.postgres_port
  }
  depends_on = [
    azurerm_kubernetes_cluster.kube_cluster,
    kubernetes_namespace.sonarqube
  ]
}

resource "helm_release" "sonarqube" {
  count            = var.create_sonarqube_setup ? 1 : 0
  chart            = "sonarqube"
  name             = "sonarqube"
  namespace        = var.kube_sonarqube_namespace
  repository       = "https://SonarSource.github.io/helm-chart-sonarqube"
  version          = "10.8.1"
  create_namespace = true
  cleanup_on_fail  = false
  recreate_pods    = true
  verify           = false
  wait             = true
  timeout          = 1200
  values = [
    file("${path.module}/helm-charts/sonarqube-values.yaml")
  ]
  set {
    name  = "jdbcOverwrite.jdbcUrl"
    value = "jdbc:postgresql://${var.create_postgres ? azurerm_postgresql_flexible_server.postgres_server[0].fqdn : null}:${var.postgres_port}/${var.postgres_sonarqube_db_name}"
  }
  set {
    name  = "jdbcOverwrite.jdbcUsername"
    value = var.postgres_sonarqube_user
  }
  set {
    name  = "jdbcOverwrite.jdbcSecretName"
    value = "sonarqube-secrets"
  }
  set {
    name  = "jdbcOverwrite.jdbcSecretPasswordKey"
    value = "PG_PASSWORD"
  }
  set {
    name  = "setAdminPassword.newPassword"
    value = var.create_sonarqube_setup ? random_password.sonarqube_admin_password[0].result : ""
  }
  depends_on = [
    azurerm_kubernetes_cluster.kube_cluster,
    kubernetes_secret_v1.sonarqube_secret
  ]
}
