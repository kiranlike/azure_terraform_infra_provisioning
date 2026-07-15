# resource "azurerm_log_analytics_workspace" "kube_log_analytics_workspace" {
#   count               = var.create_aks ? 1 : 0
#   name                = var.kube_log_analytics_workspace_name
#   location            = var.resource_location
#   resource_group_name = azurerm_resource_group.main_resource_group.name
#   sku                 = "PerGB2018"
#   retention_in_days   = 30
#   tags = {
#     name        = var.kube_log_analytics_workspace_name
#     environment = var.environment
#   }
#   depends_on = [
#     azurerm_resource_group.main_resource_group
#   ]
# }

# resource "azurerm_log_analytics_solution" "kube_log_analytics_solution" {
#   count                 = var.create_aks ? 1 : 0
#   resource_group_name   = azurerm_resource_group.main_resource_group.name
#   location              = var.resource_location
#   solution_name         = var.kube_log_analytics_solution_name
#   workspace_name        = azurerm_log_analytics_workspace.kube_log_analytics_workspace[0].name
#   workspace_resource_id = azurerm_log_analytics_workspace.kube_log_analytics_workspace[0].id
#   plan {
#     product   = "OMSGallery/ContainerInsights"
#     publisher = "Microsoft"
#   }
#   tags = {
#     name        = var.kube_log_analytics_solution_name
#     environment = var.environment
#   }
#   depends_on = [
#     azurerm_log_analytics_workspace.kube_log_analytics_workspace
#   ]
# }

resource "azurerm_public_ip" "kube_outbound_ip" {
  count               = var.create_aks ? 1 : 0
  name                = var.kube_outbound_ip_name
  location            = var.resource_location
  resource_group_name = azurerm_resource_group.main_resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    name        = var.kube_outbound_ip_name
    environment = var.environment
  }
  depends_on = [
    azurerm_resource_group.main_resource_group
  ]
}

resource "azurerm_kubernetes_cluster" "kube_cluster" {
  count                             = var.create_aks ? 1 : 0
  name                              = var.kube_cluster_name
  kubernetes_version                = data.azurerm_kubernetes_service_versions.current.latest_version
  # kubernetes_version                = "1.35.5"
  location                          = var.resource_location
  resource_group_name               = azurerm_resource_group.main_resource_group.name
  dns_prefix                        = var.kube_cluster_name
  sku_tier                          = "Standard"
  role_based_access_control_enabled = true
  node_resource_group               = "${azurerm_resource_group.main_resource_group.name}-kube"
  http_application_routing_enabled  = false
  image_cleaner_enabled             = true
  image_cleaner_interval_hours      = 168
  automatic_upgrade_channel         = "patch"
  default_node_pool {
    name                        = "pool"
    temporary_name_for_rotation = "rotationpool"
    vm_size                     = var.kube_vm_size
    orchestrator_version        = data.azurerm_kubernetes_service_versions.current.latest_version
    # orchestrator_version        = "1.35.5"
    type                        = "VirtualMachineScaleSets"
    vnet_subnet_id              = azurerm_subnet.kube_subnet[0].id
    # availability_zones   = [1, 2, 3]
    min_count            = var.kube_min_node_count
    max_count            = var.kube_max_node_count
    auto_scaling_enabled = true
    os_disk_size_gb      = var.kube_os_disk_size_gb
    max_pods             = 110
    node_labels = {
      "kube" = "pool"
    }
   tags = merge(local.common_tags, {
      name = "pool"
    })
  }
  identity {
    type = "SystemAssigned"
  }
  # oms_agent {
  #   log_analytics_workspace_id = azurerm_log_analytics_workspace.kube_log_analytics_workspace[0].id
  # }
  azure_active_directory_role_based_access_control {
    admin_group_object_ids = var.kube_admin_group_object_ids
    azure_rbac_enabled     = false
  }
  network_profile {
    load_balancer_profile {
      outbound_ip_address_ids = [
        azurerm_public_ip.kube_outbound_ip[0].id
      ]
    }
    network_plugin = var.kube_network_plugin
    service_cidr   = var.kube_services_address_space
    dns_service_ip = var.kube_dns_service_ip
  }
  # tags = {
  #   # name        = var.kube_cluster_name
  #   # environment = var.environment
  # }
  tags = merge(local.common_tags, {
      name = var.kube_cluster_name
    })

  depends_on = [
    azurerm_subnet.kube_subnet,
    # azurerm_log_analytics_workspace.kube_log_analytics_workspace,
    azurerm_public_ip.kube_outbound_ip
  ]
  lifecycle {
    ignore_changes = [
      default_node_pool[0].upgrade_settings,
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "kube_nodepool_for_gpu" {
  count                 = var.create_aks_gpu_nodepool ? 1 : 0
  name                  = "gpupool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.kube_cluster[0].id
  vm_size               = "Standard_NC6s_v3"
  node_count            = 1
  max_pods              = 110
  os_type               = "Linux"
  min_count             = var.kube_min_node_count
  max_count             = var.kube_max_node_count
  orchestrator_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  # orchestrator_version        = "1.33.11"
  os_disk_size_gb       = var.kube_os_disk_size_gb
  vnet_subnet_id        = azurerm_subnet.kube_subnet[0].id
  node_labels = {
    "dedicated" = "gpupool"
  }
  node_taints = [
    "dedicated=gpupool:NoSchedule"
  ]
  tags = {
    name        = "gpupool"
    environment = var.environment
  }
}
