# resource "kubernetes_cluster_role_binding" "dns_manager_crb" {
#   count = var.create_dns_manager_resources ? 1 : 0
#   metadata {
#     name = "dns-manager"
#   }
#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "ClusterRole"
#     name      = "cluster-admin"
#   }
#   subject {
#     kind      = "ServiceAccount"
#     name      = kubernetes_service_account.dns_manager_sa[count.index].metadata[0].name
#     namespace = kubernetes_service_account.dns_manager_sa[count.index].metadata[0].namespace
#   }
# }

# resource "kubernetes_secret" "dns_manager_secret_token" {
#   count = var.create_dns_manager_resources ? 1 : 0
#   metadata {
#     name      = "dns-manager-token"
#     namespace = "kube-system"
#     annotations = {
#       "kubernetes.io/service-account.name" = kubernetes_service_account.dns_manager_sa[count.index].metadata[0].name
#     }
#   }
#   type = "kubernetes.io/service-account-token"
#   depends_on = [
#     azurerm_kubernetes_cluster.kube_cluster,
#   ]
# }

# data "kubernetes_secret" "dns_manager_secret_token" {
#   count = var.create_dns_manager_dns_record ? 1 : 0
#   metadata {
#     name      = "dns-manager-token"
#     namespace = "kube-system"
#   }
# }

# resource "kubernetes_secret_v1" "dns_manager_secret" {
#   count = var.create_dns_manager_resources ? 1 : 0
#   type  = "kubernetes.io/Opaque"
#   metadata {
#     name      = "dns-manager-secrets"
#     namespace = var.kube_devops_namespace
#   }
#   data = {
#     AUTH_TOKEN                    = var.dns_manager_auth_token
#     AZURE_CLIENT_ID               = var.dns_manager_azure_client_id
#     AZURE_CLIENT_SECRET           = var.dns_manager_azure_client_secret
#     AZURE_DNS_RESOURCE_GROUP_NAME = var.dns_resource_group_name
#     AZURE_DNS_ZONE_NAME           = var.environment == "production" ? var.dns_zone_name : "gettruepower.net"
#     AZURE_RESOURCE_GROUP_NAME     = "${var.environment_prefix}-${var.environment}"
#     AZURE_SUBSCRIPTION_ID         = var.azure_subscription_id
#     AZURE_TENANT_ID               = data.azurerm_client_config.current.tenant_id
#     BASE_API_PATH                 = "/api/v1"
#     CDN_PROFILE_NAME              = "${var.environment_prefix}-${var.cdn_profile_name}"
  #  K8S_INGRESS_IP_ADDRESS        = "135.235.10.147"

#     K8S_SERVER                    = "https://${azurerm_kubernetes_cluster.kube_cluster[count.index].fqdn}:443"
#     K8S_TOKEN                     = data.kubernetes_secret.dns_manager_secret_token[count.index].data["token"]
#     NODE_ENV                      = var.environment
#     NODE_SERVER_PORT              = 3000
#     PARTNER_ENDPOINT_NAME         = "${var.environment_prefix}-${var.partnerweb_cdn_endpoint_name}"
#     WEBAPP_ENDPOINT_NAME          = "${var.environment_prefix}-${var.cpoweb_cdn_endpoint_name}"
#     WEBVIEW_ENDPOINT_NAME         = "${var.environment_prefix}-${var.webview_cdn_endpoint_name}"
#     OTEL_EXPORTER                 = "otlp"
#     OTEL_EXPORTER_OTLP_ENDPOINT   = var.otel_exporter_endpoint
#     OTEL_EXPORTER_OTLP_HEADERS    = var.create_signoz_stack ? random_password.signoz_otel_exporter_secret[count.index].result : ""
#     OTEL_EXPORTER_OTLP_INSECURE   = "false"
#     OTEL_SERVICE_NAME             = "dns-manager"
#   }
#   depends_on = [
#     azurerm_kubernetes_cluster.kube_cluster,
#     kubernetes_secret.dns_manager_secret_token
#   ]
# }