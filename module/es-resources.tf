# # resource "elasticsearch_role" "es_read_write_role" {
# #   count = var.create_eck_stack ? 1 : 0
# #   name  = "read_write"
# #   indices {
# #     names      = ["device-logs*"]
# #     privileges = ["all"]
# #     # allow_restricted_indices = false
# #   }
# #   #   indices {
# #   #     names      = [""]
# #   #     privileges = ["read"]
# #   #   }
# #   run_as  = ["device"]
# #   cluster = ["read_ccr"]
# #   depends_on = [
# #     kubernetes_manifest.elasticsearch
# #   ]
# # }

# # resource "random_password" "es_read_write_users_password" {
# #   for_each = var.create_eck_stack ? toset(var.es_read_write_users) : toset([])
# #   length   = 28
# #   special  = false
# #   lifecycle {
# #     ignore_changes = [special]
# #   }
# #   depends_on = []
# # }

# # resource "elasticsearch_user" "es_read_write_users" {
# #   for_each  = var.create_eck_stack ? toset(var.es_read_write_users) : toset([])
# #   username  = each.value
# #   enabled   = "true"
# #   email     = ""
# #   full_name = each.value
# #   password  = random_password.es_read_write_users_password[each.value].result
# #   roles     = [elasticsearch_role.es_read_write_role[0].name, "remote_monitoring_agent", "remote_monitoring_collector", "kibana_admin", "reporting_user"]
# #   depends_on = [
# #     elasticsearch_role.es_read_write_role
# #   ]
# # }

# # resource "random_password" "es_superuser_users_password" {
# #   for_each = var.create_eck_stack ? toset(var.es_superuser_users) : toset([])
# #   length   = 28
# #   special  = false
# #   lifecycle {
# #     ignore_changes = [special]
# #   }
# #   depends_on = []
# # }

# # resource "elasticsearch_user" "es_superuser_users" {
# #   for_each  = var.create_eck_stack ? toset(var.es_superuser_users) : toset([])
# #   username  = each.value
# #   enabled   = "true"
# #   email     = ""
# #   full_name = each.value
# #   password  = random_password.es_superuser_users_password[each.value].result
# #   roles     = ["superuser"]
# #   depends_on = [
# #     kubernetes_manifest.elasticsearch
# #   ]
# # }

# resource "helm_release" "eck_operator" {
#   count            = var.create_eck_stack ? 1 : 0
#   chart            = "eck-operator"
#   name             = "eck-operator"
#   # namespace        = var.kube_eck_operator_namespace
#   namespace        = "elastic-system"
#   repository       = "https://helm.elastic.co"
#   version          = "2.14.0"
#   create_namespace = true
#   cleanup_on_fail  = false
#   recreate_pods    = true
#   verify           = false
#   wait             = true
#   values = [
#     file("${path.module}/helm-charts/eck-operator-values.yaml")
#   ]
#   depends_on = [
#     azurerm_kubernetes_cluster.kube_cluster,
#   ]
# }

# resource "kubernetes_manifest" "elasticsearch" {
#   count = var.create_eck_stack ? 1 : 0
#   manifest = yamldecode(templatefile("${path.module}/kubernetes/elasticsearch.yaml", {
#     ELASTICSEARCH_HOST = "${var.es_dns_prefix}.${var.dns_zone_name}",
#   }))
#   field_manager {
#     force_conflicts = true
#   }
#   depends_on = [
#     azurerm_kubernetes_cluster.kube_cluster,
#     helm_release.eck_operator
#   ]
# }

# resource "kubernetes_manifest" "kibana" {
#   count = var.create_eck_stack ? 1 : 0
#   manifest = yamldecode(templatefile("${path.module}/kubernetes/kibana.yaml", {
#     KIBANA_HOST = "${var.kibana_dns_prefix}.${var.dns_zone_name}",
#   }))
#   field_manager {
#     force_conflicts = true
#   }
#   depends_on = [
#     azurerm_kubernetes_cluster.kube_cluster,
#     helm_release.eck_operator
#   ]
# }

# # # resource "kubernetes_manifest" "filebeat" {
# # #   for_each = {
# # #     for manifest in yamldecode(file("${path.module}/kubernetes/filebeat.yaml")) :
# # #     "${lower(manifest.kind)}-${manifest.metadata.name}" => manifest
# # #     if var.create_eck_stack
# # #   }

# # #   manifest = each.value

# # #   field_manager {
# # #     force_conflicts = true
# # #   }

# # #   depends_on = [
# # #     azurerm_kubernetes_cluster.kube_cluster,
# #     helm_release.eck_operator
# #   ]
# # }

# # resource "kubernetes_manifest" "filebeat" {
# #   for_each = {
# #     for manifest in provider::kubernetes::manifest_decode_multi(file("${path.module}/kubernetes/filebeat.yaml")) :
# #     "${lower(manifest.kind)}-${manifest.metadata.name}" => manifest
# #     if var.create_eck_stack
# #   }
# #   manifest = each.value
# #   field_manager {
# #     force_conflicts = true
# #   }
# #   depends_on = [
# #     azurerm_kubernetes_cluster.kube_cluster,
# #     helm_release.eck_operator
# #   ]
# # }

# resource "kubernetes_service_account" "dns_manager_sa" {
#   count = var.create_dns_manager_resources ? 1 : 0
#   metadata {
#     name      = "dns-manager"
#     namespace = "kube-system"
#   }
# }
