resource "kubernetes_service_v1" "keycloak_service" {
  metadata {
    name      = "keycloak"
    namespace = "keycloak"
    labels = {
      app = "keycloak"
    }
  }
  spec {
    selector = {
      app = "keycloak"
    }
    port {
      name        = "http"
      port        = 8080
      target_port = 8080
    }
    type = "ClusterIP"
  }
  depends_on = [
    kubernetes_namespace_v1.keycloak_namespace
  ]
}