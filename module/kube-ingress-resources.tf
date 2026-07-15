# data "kubernetes_service_v1" "ingress_ip_service" {
#   count = var.create_aks ? 1 : 0
#   metadata {
#     name      = "ingress-nginx-controller"
#     namespace = "ingress-nginx"
#   }
#   depends_on = [
#     azurerm_kubernetes_cluster.kube_cluster
#   ]
# }

resource "kubernetes_manifest" "cluster_issuer" {
  count = var.create_aks ? 1 : 0
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "cluster-issuer"
    }
    spec = {
      acme = {
        server = "https://acme-v02.api.letsencrypt.org/directory"
        email  = "alert@enercent.co"
        privateKeySecretRef = {
          name = "cluster-issuer-secret"
        }
        solvers = [
          {
            http01 = {
              ingress = {
                class = "nginx"
              }
            }
          }
        ]
      }
    }
  }
  depends_on = [
    azurerm_kubernetes_cluster.kube_cluster,
  ]
}

# resource "kubernetes_ingress_v1" "backend_ingress" {
#   count = var.create_backend_dns_record ? 1 : 0
#   metadata {
#     name      = "backend-ingress"
#     namespace = var.kube_microservices_namespace
#     labels = {
#       app = "backend-ingress"
#     }
#     annotations = {
#       "cert-manager.io/cluster-issuer" : "cluster-issuer"
#       "nginx.ingress.kubernetes.io/proxy-body-size" : "0"
#       "nginx.ingress.kubernetes.io/proxy-read-timeout" : "360"
#       "nginx.ingress.kubernetes.io/proxy-send-timeout" : "360"
#       "kubernetes.io/ingress.class" : "nginx"
#     }
#   }
#   spec {
#     ingress_class_name = "nginx"
#     default_backend {
#       service {
#         name = "backend-ror-service"
#         port {
#           number = 3000
#         }
#       }
#     }
#     tls {
#       secret_name = "backend-ingress-secret"
#       hosts = [
#         "${var.backend_dns_prefix}.${var.dns_zone_name}"
#       ]
#     }
#     rule {
#       host = "${var.backend_dns_prefix}.${var.dns_zone_name}"
#       http {
#         path {
#           backend {
#             service {
#               name = "backend-ror-service"
#               port {
#                 number = 3000
#               }
#             }
#           }
#           path_type = "Prefix"
#           path      = "/"
#         }
#       }
#     }
#   }
#   depends_on = [
#     azurerm_dns_a_record.backend_dns_record,
#     azurerm_kubernetes_cluster.kube_cluster,
#   ]
# }

# # resource "kubernetes_ingress_v1" "cms_ingress" {
# #   count = var.create_cms_dns_record ? 1 : 0
# #   metadata {
# #     name      = "cms-ingress"
# #     namespace = var.kube_microservices_namespace
# #     labels = {
# #       app = "cms-ingress"
# #     }
# #     annotations = {
# #       "cert-manager.io/cluster-issuer" : "cluster-issuer"
# #       "nginx.ingress.kubernetes.io/proxy-read-timeout" : "360"
# #       "nginx.ingress.kubernetes.io/proxy-send-timeout" : "360"
# #       "kubernetes.io/ingress.class" : "nginx"
# #     }
# #   }
# #   spec {
# #     ingress_class_name = "nginx"
# #     tls {
# #       secret_name = "cms-ingress-secret"
# #       hosts = [
# #         "${var.cms_dns_prefix}.${var.dns_zone_name}"
# #       ]
# #     }
# #     rule {
# #       host = "${var.cms_dns_prefix}.${var.dns_zone_name}"
# #       http {
# #         path {
# #           backend {
# #             service {
# #               name = "cms-ocpp-service"
# #               port {
# #                 number = 1000
# #               }
# #             }
# #           }
# #           path_type = "Prefix"
# #           path      = "/"
# #         }
# #       }
# #     }
# #   }
# #   depends_on = [
# #     azurerm_kubernetes_cluster.kube_cluster,
# #     azurerm_dns_a_record.cms_dns_record
# #   ]
# # }

# # resource "kubernetes_ingress_v1" "analytics_ingress" {
# #   count = var.create_analytics_dns_record ? 1 : 0
# #   metadata {
# #     name      = "analytics-ingress"
# #     namespace = var.kube_microservices_namespace
# #     labels = {
# #       app = "analytics-ingress"
# #     }
# #     annotations = {
# #       "cert-manager.io/cluster-issuer" : "cluster-issuer"
# #       "nginx.ingress.kubernetes.io/proxy-body-size" : "0"
# #       "nginx.ingress.kubernetes.io/proxy-read-timeout" : "360"
# #       "nginx.ingress.kubernetes.io/proxy-send-timeout" : "360"
# #       "kubernetes.io/ingress.class" : "nginx"
# #     }
# #   }
# #   spec {
# #     ingress_class_name = "nginx"
# #     tls {
# #       secret_name = "analytics-ingress-secret"
# #       hosts = [
# #         "${var.analytics_dns_prefix}.${var.dns_zone_name}"
# #       ]
# #     }
# #     rule {
# #       host = "${var.analytics_dns_prefix}.${var.dns_zone_name}"
# #       http {
# #         path {
# #           backend {
# #             service {
# #               name = "analytics-service"
# #               port {
# #                 number = 1000
# #               }
# #             }
# #           }
# #           path_type = "Prefix"
# #           path      = "/"
# #         }
# #       }
# #     }
# #   }
# #   depends_on = [
# #     azurerm_kubernetes_cluster.kube_cluster,
# #     azurerm_dns_a_record.analytics_dns_record
# #   ]
# # }

# # resource "kubernetes_ingress_v1" "dns_manager_ingress" {
# #   count = var.create_dns_manager_dns_record && var.create_dns_manager_resources ? 1 : 0
# #   metadata {
# #     name      = "dns-manager-ingress"
# #     namespace = var.kube_devops_namespace
# #     labels = {
# #       app = "dns-manager-ingress"
# #     }
# #     annotations = {
# #       "cert-manager.io/cluster-issuer" : "cluster-issuer"
# #       "nginx.ingress.kubernetes.io/proxy-read-timeout" : "360"
# #       "nginx.ingress.kubernetes.io/proxy-send-timeout" : "360"
# #       "kubernetes.io/ingress.class" : "nginx"
# #     }
# #   }
# #   spec {
# #     ingress_class_name = "nginx"
# #     tls {
# #       secret_name = "dns-manager-ingress-secret"
# #       hosts = [
# #         "${var.dns_manager_dns_prefix}.${var.dns_zone_name}"
# #       ]
# #     }
# #     rule {
# #       host = "${var.dns_manager_dns_prefix}.${var.dns_zone_name}"
# #       http {
# #         path {
# #           backend {
# #             service {
# #               name = "dns-manager-service"
# #               port {
# #                 number = 80
# #               }
# #             }
# #           }
# #           path_type = "Prefix"
# #           path      = "/"
# #         }
# #       }
# #     }
# #   }
# #   depends_on = [
# #     azurerm_kubernetes_cluster.kube_cluster,
# #     azurerm_dns_a_record.dns_manager_dns_record
# #   ]
# # }

resource "kubernetes_ingress_v1" "kube_ingress" {
  count = var.create_kube_dns_record && var.create_kubernetes_dashboard ? 1 : 0
  metadata {
    name      = "kube-ingress"
    namespace = var.kube_dashboard_namespace
    labels = {
      app = "kube-ingress"
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
      secret_name = "kube-ingress-secret"
      hosts = [
        "${var.kube_dns_prefix}.${var.dns_zone_name}"
      ]
    }
    rule {
      host = "${var.kube_dns_prefix}.${var.dns_zone_name}"
      http {
        path {
          backend {
            service {
              name = "kubernetes-dashboard-kong-proxy"
              port {
                number = 80
              }
            }
          }
          path_type = "Prefix"
          path      = "/"
        }
      }
    }
  }
  depends_on = [
    azurerm_kubernetes_cluster.kube_cluster,
    azurerm_dns_a_record.kube_dns_record,
    helm_release.kubernetes_dashboard
  ]
}

# # resource "kubernetes_ingress_v1" "es_ingress" {
# #   count = var.create_es_dns_record ? 1 : 0 # TODO: add  && var.create_eck_stack
# #   metadata {
# #     name      = "es-ingress"
# #     namespace = var.kube_eck_stack_namespace
# #     labels = {
# #       app = "es-ingress"
# #     }
# #     annotations = {
# #       "cert-manager.io/cluster-issuer" : "cluster-issuer"
# #       "nginx.ingress.kubernetes.io/proxy-body-size" : "0"
# #       "nginx.ingress.kubernetes.io/backend-protocol" : "HTTPS"
# #       "nginx.ingress.kubernetes.io/force-ssl-redirect" : true
# #       "kubernetes.io/ingress.class" : "nginx"
# #     }
# #   }
# #   spec {
# #     ingress_class_name = "nginx"
# #     tls {
# #       secret_name = "es-ingress-secret"
# #       hosts = [
# #         "${var.es_dns_prefix}.${var.dns_zone_name}"
# #       ]
# #     }
# #     rule {
# #       host = "${var.es_dns_prefix}.${var.dns_zone_name}"
# #       http {
# #         path {
# #           backend {
# #             service {
# #               name = "elasticsearch-es-http"
# #               port {
# #                 number = 9200
# #               }
# #             }
# #           }
# #           path_type = "Prefix"
# #           path      = "/"
# #         }
# #       }
# #     }
# #   }
# #   depends_on = [
# #     azurerm_kubernetes_cluster.kube_cluster,
# #     azurerm_dns_a_record.es_dns_record,
# #   ]
# # }

# # resource "kubernetes_ingress_v1" "kibana_ingress" {
# #   count = var.create_kibana_dns_record ? 1 : 0 # TODO: add  && var.create_eck_stack
# #   metadata {
# #     name      = "kibana-ingress"
# #     namespace = var.kube_eck_stack_namespace
# #     labels = {
# #       app = "kibana-ingress"
# #     }
# #     annotations = {
# #       "cert-manager.io/cluster-issuer" : "cluster-issuer"
# #       "nginx.ingress.kubernetes.io/proxy-body-size" : "0"
# #       "nginx.ingress.kubernetes.io/proxy-read-timeout" : "360"
# #       "nginx.ingress.kubernetes.io/proxy-send-timeout" : "360"
# #       "kubernetes.io/ingress.class" : "nginx"
# #     }
# #   }
# #   spec {
# #     ingress_class_name = "nginx"
# #     tls {
# #       secret_name = "kibana-ingress-secret"
# #       hosts = [
# #         "${var.kibana_dns_prefix}.${var.dns_zone_name}"
# #       ]
# #     }
# #     rule {
# #       host = "${var.kibana_dns_prefix}.${var.dns_zone_name}"
# #       http {
# #         path {
# #           backend {
# #             service {
# #               name = "kibana-kb-http"
# #               port {
# #                 number = 5601
# #               }
# #             }
# #           }
# #           path_type = "Prefix"
# #           path      = "/"
# #         }
# #       }
# #     }
# #   }
# #   depends_on = [
# #     azurerm_kubernetes_cluster.kube_cluster,
# #     azurerm_dns_a_record.kibana_dns_record,
# #   ]
# # }

# # resource "kubernetes_ingress_v1" "signoz_ingress" {
# #   count = var.create_signoz_dns_record && var.create_signoz_stack ? 1 : 0
# #   metadata {
# #     name      = "signoz-ingress"
# #     namespace = var.kube_signoz_stack_namespace
# #     labels = {
# #       app = "signoz-ingress"
# #     }
# #     annotations = {
# #       "cert-manager.io/cluster-issuer" : "cluster-issuer"
# #       "nginx.ingress.kubernetes.io/proxy-body-size" : "0"
# #       "nginx.ingress.kubernetes.io/proxy-read-timeout" : "360"
# #       "nginx.ingress.kubernetes.io/proxy-send-timeout" : "360"
# #       "kubernetes.io/ingress.class" : "nginx"
# #     }
# #   }
# #   spec {
# #     ingress_class_name = "nginx"
# #     tls {
# #       secret_name = "signoz-ingress-secret"
# #       hosts = [
# #         "${var.signoz_dns_prefix}.${var.dns_zone_name}"
# #       ]
# #     }
# #     rule {
# #       host = "${var.signoz_dns_prefix}.${var.dns_zone_name}"
# #       http {
# #         path {
# #           backend {
# #             service {
# #               name = "signoz-frontend"
# #               port {
# #                 number = 3301
# #               }
# #             }
# #           }
# #           path_type = "Prefix"
# #           path      = "/"
# #         }
# #       }
# #     }
# #   }
# #   depends_on = [
# #     azurerm_kubernetes_cluster.kube_cluster,
# #     azurerm_dns_a_record.kibana_dns_record,
# #     kubernetes_namespace.signoz
# #   ]
# # }

# # resource "kubernetes_ingress_v1" "ghost_ingress" {
# #   count = var.create_ghost_dns_record && var.create_ghost_stack ? 1 : 0
# #   metadata {
# #     name      = "ghost-ingress"
# #     namespace = var.kube_ghost_namespace
# #     labels = {
# #       app = "ghost-ingress"
# #     }
# #     annotations = {
# #       "cert-manager.io/cluster-issuer" : "cluster-issuer"
# #       "nginx.ingress.kubernetes.io/proxy-read-timeout" : "360"
# #       "nginx.ingress.kubernetes.io/proxy-send-timeout" : "360"
# #       "kubernetes.io/ingress.class" : "nginx"
# #     }
# #   }
# #   spec {
# #     ingress_class_name = "nginx"
# #     tls {
# #       secret_name = "ghost-ingress-secret"
# #       hosts = [
# #         "${var.ghost_dns_prefix}.${var.dns_zone_name}"
# #       ]
# #     }
# #     rule {
# #       host = "${var.ghost_dns_prefix}.${var.dns_zone_name}"
# #       http {
# #         path {
# #           backend {
# #             service {
# #               name = "ghost-service"
# #               port {
# #                 name = "ghk8s"
# #               }
# #             }
# #           }
# #           path_type = "ImplementationSpecific"
# #           path      = "/"
# #         }
# #       }
# #     }
# #   }
# #   depends_on = [
# #     azurerm_kubernetes_cluster.kube_cluster,
# #     azurerm_dns_a_record.sonarqube_dns_record,
# #   ]

# # }

# # resource "kubernetes_ingress_v1" "sonarqube_ingress" {
# #   count = var.create_sonarqube_dns_record && var.create_sonarqube_setup ? 1 : 0
# #   metadata {
# #     name      = "sonarqube-ingress"
# #     namespace = var.kube_sonarqube_namespace
# #     labels = {
# #       app = "sonarqube-ingress"
# #     }
# #     annotations = {
# #       "cert-manager.io/cluster-issuer" : "cluster-issuer"
# #       "nginx.ingress.kubernetes.io/proxy-read-timeout" : "360"
# #       "nginx.ingress.kubernetes.io/proxy-send-timeout" : "360"
# #       "kubernetes.io/ingress.class" : "nginx"
# #     }
# #   }
# #   spec {
# #     ingress_class_name = "nginx"
# #     tls {
# #       secret_name = "sonarqube-ingress-secret"
# #       hosts = [
# #         "${var.sonarqube_dns_prefix}.${var.dns_zone_name}"
# #       ]
# #     }
# #     rule {
# #       host = "${var.sonarqube_dns_prefix}.${var.dns_zone_name}"
# #       http {
# #         path {
# #           backend {
# #             service {
# #               name = "sonarqube-sonarqube"
# #               port {
# #                 number = 9000
# #               }
# #             }
# #           }
# #           path_type = "Prefix"
# #           path      = "/"
# #         }
# #       }
# #     }
# #   }
# #   depends_on = [
# #     azurerm_kubernetes_cluster.kube_cluster,
# #     azurerm_dns_a_record.sonarqube_dns_record,
# #     kubernetes_namespace.sonarqube
# #   ]
# # }
