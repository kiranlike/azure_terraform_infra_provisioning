terraform {
  required_providers {
    elasticsearch = {
      source  = "disaster37/elasticsearch"
      version = "8.4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.33.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.12.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.12.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.3"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
}

provider "helm" {
  kubernetes {
    host                   = var.create_aks ? azurerm_kubernetes_cluster.kube_cluster[0].kube_admin_config.0.host : null
    username               = var.create_aks ? azurerm_kubernetes_cluster.kube_cluster[0].kube_admin_config.0.username : null
    password               = var.create_aks ? azurerm_kubernetes_cluster.kube_cluster[0].kube_admin_config.0.password : null
    client_certificate     = var.create_aks ? base64decode(azurerm_kubernetes_cluster.kube_cluster[0].kube_admin_config.0.client_certificate) : null
    client_key             = var.create_aks ? base64decode(azurerm_kubernetes_cluster.kube_cluster[0].kube_admin_config.0.client_key) : null
    cluster_ca_certificate = var.create_aks ? base64decode(azurerm_kubernetes_cluster.kube_cluster[0].kube_admin_config.0.cluster_ca_certificate) : null
  }
}

provider "kubernetes" {
  host                   = var.create_aks ? azurerm_kubernetes_cluster.kube_cluster[0].kube_admin_config.0.host : null
  username               = var.create_aks ? azurerm_kubernetes_cluster.kube_cluster[0].kube_admin_config.0.username : null
  password               = var.create_aks ? azurerm_kubernetes_cluster.kube_cluster[0].kube_admin_config.0.password : null
  client_certificate     = var.create_aks ? base64decode(azurerm_kubernetes_cluster.kube_cluster[0].kube_admin_config.0.client_certificate) : null
  client_key             = var.create_aks ? base64decode(azurerm_kubernetes_cluster.kube_cluster[0].kube_admin_config.0.client_key) : null
  cluster_ca_certificate = var.create_aks ? base64decode(azurerm_kubernetes_cluster.kube_cluster[0].kube_admin_config.0.cluster_ca_certificate) : null
}

# provider "elasticsearch" {
#   urls     = "https://${var.es_dns_prefix}.${var.dns_zone_name}"
#   username = "elastic"
#   password = var.create_eck_stack ? data.kubernetes_secret.elastic_admin_secret[0].data["elastic"] : null
# }
# provider "elasticsearch" {
#   urls     = "https://${var.es_dns_prefix}.${var.dns_zone_name}"
#   username = "elastic"
#   password = var.create_eck_stack ? data.kubernetes_secret.elastic_admin_secret != null ? data.kubernetes_secret.elastic_admin_secret[0].data["elastic"] : null : null
# }