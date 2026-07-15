output "postgres" {
  value = {
    # id         = var.create_postgres ? azurerm_postgresql_flexible_server.postgres_server[0].id : null
    admin = {
      username   = var.postgres_admin_user
      password   = var.create_postgres ? var.postgres_admin_password : null
      db         = "all db can be accessed" // just a note
      host       = var.create_postgres ? azurerm_postgresql_flexible_server.postgres_server[0].fqdn : null
      port       = var.postgres_port
      private_ip = "to be added" // TODO: setup private IP
    },
    # cms = {
    #   username   = var.postgres_cms_ocpp_user
    #   password   = var.postgres_cms_ocpp_password
    #   db         = var.postgres_cms_db_name
    #   host       = var.create_postgres ? azurerm_postgresql_flexible_server.postgres_server[0].fqdn : null
    #   port       = var.postgres_port
    #   private_ip = "to be added" // TODO: setup private IP
    # },
    # papertrail = {
    #   username   = var.postgres_papertrail_user
    #   password   = var.postgres_papertrail_password
    #   db         = var.postgres_papertrail_db_name
    #   host       = var.create_postgres ? azurerm_postgresql_flexible_server.postgres_server[0].fqdn : null
    #   port       = var.postgres_port
    #   private_ip = "to be added" // TODO: setup private IP
    # },
    # sonarqube = {
    #   username   = var.postgres_sonarqube_user
    #   password   = var.create_sonarqube_setup ? random_password.postgres_sonarqube_password[0].result : null
    #   db         = var.postgres_sonarqube_db_name
    #   host       = var.create_postgres ? azurerm_postgresql_flexible_server.postgres_server[0].fqdn : null
    #   port       = var.postgres_port
    #   private_ip = "to be added" // TODO: setup private IP
    # }
    backup = {
      enabled             = var.create_pg_backup_cronjob
      # backup_zip_password = var.create_pg_backup_cronjob ? random_password.postgres_secure_file_password[0].result : null
    }
  }
  sensitive = true
}
