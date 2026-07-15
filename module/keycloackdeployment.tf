resource "kubernetes_deployment_v1" "keycloak_deployment" {
  metadata {
    name      = "keycloak"
    namespace = "keycloak"
    labels = {
      app = "keycloak"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "keycloak"
      }
    }
    template {
      metadata {
        labels = {
          app = "keycloak"
        }
      }
      spec {
        container {
          name  = "keycloak"
          image = "quay.io/keycloak/keycloak:23.0.1"
          args  = ["start"]
          resources {
            limits = {
              cpu    = "1000m"
              memory = "2048Mi"
            }
            requests = {
              cpu    = "500m"
              memory = "1024Mi"
            }
          }
          port {
            name           = "http"
            container_port = 8080
          }
        #   readiness_probe {
        #     http_get {
        #       path = "/health/ready"
        #       port = 8080
        #     }
        #     initial_delay_seconds = 250
        #     period_seconds        = 10
        #     timeout_seconds       = 5
        #     success_threshold     = 1
        #     failure_threshold     = 3
        #   }
        #   liveness_probe {
        #     http_get {
        #       path = "/health/live"
        #       port = 8080
        #     }
        #     initial_delay_seconds = 500
        #     period_seconds        = 30
        #     timeout_seconds       = 5
        #     success_threshold     = 1
        #     failure_threshold     = 3
        #   }
          env_from {
            secret_ref {
              name = kubernetes_secret.keycloak_secret.metadata.0.name
            }
          }
        }
      }
    }
  }
  depends_on = [
    kubernetes_namespace_v1.keycloak_namespace,
    kubernetes_secret.keycloak_secret,
  ]
}