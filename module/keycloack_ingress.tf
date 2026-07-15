
# # Ref => https://raw.githubusercontent.com/keycloak/keycloak-quickstarts/latest/kubernetes/keycloak.yaml
# # Ref => https://raw.githubusercontent.com/keycloak/keycloak-quickstarts/latest/kubernetes/keycloak-ingress.yaml
# # Ingress is required only if you are exposing keykloak via domain


resource "kubernetes_ingress_v1" "keycloak_ingress" {
  # count = var.create_kube_dns_record && var.create_kubernetes_dashboard ? 1 : 0
  metadata {
    name      = "keycloak"
    namespace = "keycloak"
    labels = {
      app = "keycloak"
    }
    annotations = {
      "cert-manager.io/cluster-issuer" : "cluster-issuer"
      "nginx.ingress.kubernetes.io/proxy-read-timeout" : "360"
      "nginx.ingress.kubernetes.io/proxy-send-timeout" : "360"
      "kubernetes.io/ingress.class" : "nginx"
    }
  }
  spec {
    ingress_class_name = "nginx"
    tls {
      secret_name = "keycloak-ingress-secret"
      hosts = [
        "keycloak.gettruepower.net"
      ]
    }
    rule {
      host = "keycloak.gettruepower.net"
      http {
        path {
          backend {
            service {
              name = "keycloak"
              port {
               number = 8080
              }
            }
          }
          path_type = "Prefix"
          path      = "/"
        }
      }
    }
  }

}

resource "kubernetes_namespace_v1" "keycloak_namespace" {
  metadata {
    annotations = {
      name = "keycloak"
    }
    labels = {
      mylabel = "keycloak"
    }
    name = "keycloak"
  }
  }




