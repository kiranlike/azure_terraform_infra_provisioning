# data "kubernetes_secret" "elastic_admin_secret" {
#   count = var.create_eck_stack ? 1 : 0
#   metadata {
#     name      = "elasticsearch-es-elastic-user"
#     namespace = var.kube_eck_stack_namespace
#   }
# }

# variable "create_eck_stack" {
#   type    = bool
#   default = false
# }

# variable "kube_eck_operator_namespace" {
#   type    = string
#   default = "eck-system"
# }

# variable "kube_eck_stack_namespace" {
#   type    = string
#   default = "elasticsearch"
# }

# variable "es_private_host" {
#   type    = string
#   default = "elasticsearch-es-http.elasticsearch.svc.cluster.local:9200"
# }

# variable "es_superuser_users" {
#   type    = list(string)
#   default = []
# }

# variable "es_read_write_users" {
#   type    = list(string)
#   default = []
# }
