# locals {
#   pg_backup_cronjob_image_with_tag = var.create_container_registry ? "${azurerm_container_registry.container_registry[0].login_server}/docker/pg-backup:${var.pg_backup_cronjob_docker_image_tag}" : ""
# }

# resource "null_resource" "pg_backup_cronjob_docker_image" {
#   count = var.create_pg_backup_cronjob && var.create_container_registry ? 1 : 0
#   triggers = {
#     tag = local.pg_backup_cronjob_image_with_tag
#   }
#   provisioner "local-exec" {
#     command = <<-EOT
#       docker build -t ${local.pg_backup_cronjob_image_with_tag} --platform linux/amd64 -f ${path.module}/docker/pg-backup-image/Dockerfile ${path.module}/docker/pg-backup-image/
#       docker login ${azurerm_container_registry.container_registry[0].login_server} -u ${azurerm_container_registry.container_registry[0].admin_username} -p ${azurerm_container_registry.container_registry[0].admin_password}
#       docker push ${local.pg_backup_cronjob_image_with_tag}
#     EOT
#   }
#   depends_on = [
#     azurerm_container_registry.container_registry
#   ]
# }

# resource "kubernetes_manifest" "pg_backup_cronjob" {
#   count = var.create_pg_backup_cronjob && var.create_container_registry ? 1 : 0
#   manifest = yamldecode(templatefile("${path.module}/kubernetes/pg-backup-cronjob.yaml", {
#     RESOURCE_NAMESPACE               = var.kube_cronjobs_namespace
#     PG_BACKUP_CRONJOB_IMAGE_WITH_TAG = local.pg_backup_cronjob_image_with_tag
#     # IMAGE_PULL_SECRET_NAME = "imgpull-secret"
#   }))
#   depends_on = [
#     azurerm_kubernetes_cluster.kube_cluster,
#     kubernetes_secret_v1.pg_backup_cronjob_secret,
#     azurerm_container_registry.container_registry,
#     null_resource.pg_backup_cronjob_docker_image
#   ]
# }

# resource "random_password" "postgres_secure_file_password" {
#   count   = var.create_pg_backup_cronjob ? 1 : 0
#   length  = 54
#   special = false
#   lifecycle {
#     ignore_changes = [special]
#   }
# }

# resource "kubernetes_secret_v1" "pg_backup_cronjob_secret" {
#   count = var.create_pg_backup_cronjob ? 1 : 0
#   type  = "kubernetes.io/Opaque"
#   metadata {
#     name      = "pg-backup-cronjob-secrets"
#     namespace = var.kube_cronjobs_namespace
#   }
#   data = {
#     AZURE_CONTAINER_NAME     = var.backup_storage_account_container_name
#     AZURE_STORAGE_ACCOUNT    = "${var.environment_prefix}${var.backup_storage_account_name}"
#     AZURE_STORAGE_ACCESS_KEY = var.create_backup_storage_account ? azurerm_storage_account.backup_storage_account[0].primary_access_key : null
#     PG_PASSWORD              = var.postgres_admin_password
#     PG_USER                  = var.postgres_admin_user
#     PG_HOST                  = var.create_postgres ? azurerm_postgresql_flexible_server.postgres_server[0].fqdn : null
#     PG_PORT                  = var.postgres_port
#     PG_DB_MAIN               = var.postgres_main_db_name
#     PG_DB_PRICING            = var.postgres_pricing_db_name
#     PG_DB_TENANT             = var.postgres_tenant_db_name
#     PG_DB_METERDATA          = var.postgres_materdata_db_name
#     SECURE_FILE_PASSWORD     = random_password.postgres_secure_file_password[count.index].result
#   }
#   depends_on = [
#     azurerm_storage_container.backup_storage_account_container,
#     azurerm_kubernetes_cluster.kube_cluster,
#   ]
# }
