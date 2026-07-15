module "resources" {
  # Import module
  source = "../module"

  # Create Only Required Resources
  create_data_storage_account    = true #for uploading images
  create_backup_storage_account  = true
  create_edgeiot_storage_account = false
  # create_cpoweb_storage_account       = false
  create_operatorweb_storage_account = true
  create_consumerweb_storage_account = true
  # create_webview_storage_account      = false
  # create_adminweb_storage_account     = false
  # create_partnerweb_storage_account   = false
  # create_landingweb_dns_record        = false
  # create_cpoweb_dns_record            = false
  create_operatorweb_dns_record = true
  create_consumerweb_dns_record = true

  # create_backend_dns_record             = true
  # create_webview_dns_record           = false
  # create_adminweb_dns_record          = false
  # create_partnerweb_dns_record        = false
  create_vnet_gateway         = true
  create_container_registry   = true
  create_aks                  = true
  create_postgres             = true
  create_kube_dns_record      = true
  create_aks_gpu_nodepool     = false
  create_kubernetes_dashboard = true
  create_cosmos_db            = false
  create_pg_backup_cronjob    = false

  # DNS Variables
  resource_location = "centralindiawest"
  environment       = "staging"
  dns_zone_name     = ""

  operatorweb_dns_prefix  = ""
  consumerweb_dns_prefix  = ""
  kube_dns_prefix         = ""
  dns_resource_group_name = ""

  kube_exec_access_users = [
    "jyothi",
    "chandra-kiran",
  ]
  environment_prefix    = var.environment_prefix
  azure_subscription_id = var.azure_subscription_id
  kube_admin_group_object_ids = [
    "2fe1-4fd9-97a0-f8acbf84d2bb"
  ]
  postgres_admin_password                        = var.postgres_admin_password
  vnet_gateway_root_certificate_public_cert_data = var.vnet_gateway_root_certificate_public_cert_data
  temp_cosmosdb_connection_string                = var.temp_cosmosdb_connection_string // TODO: remove this variable when we start using correct cosmosdb
}

