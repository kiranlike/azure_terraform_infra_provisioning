resource "azurerm_dns_cname_record" "operatorweb_dns_record" {
  count               = var.create_operatorweb_dns_record ? 1 : 0
  name                = var.operatorweb_dns_prefix
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_resource_group_name
  ttl                 = 1
  # record              = "${var.environment_prefix}-${var.operatorweb_cdn_endpoint_name}.azureedge.net"
  record              = azurerm_cdn_frontdoor_endpoint.operatorweb_cdn_endpoint[0].host_name
  tags = {
    name        = var.operatorweb_dns_prefix
    environment = var.environment
  }
}
resource "azurerm_dns_cname_record" "consumer_dns_record" {
  count               = var.create_consumerweb_dns_record ? 1 : 0
  name                = var.consumerweb_dns_prefix
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_resource_group_name
  ttl                 = 1
  # record              = "${var.environment_prefix}-${var.consumerweb_cdn_endpoint_name}.azureedge.net"
  record              = azurerm_cdn_frontdoor_endpoint.consumerweb_cdn_endpoint[0].host_name
  tags = {
    name        = var.consumerweb_dns_prefix
    environment = var.environment
  }
}

resource "azurerm_dns_a_record" "kube_dns_record" {
  count               = var.create_kube_dns_record ? 1 : 0
  name                = var.kube_dns_prefix
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_resource_group_name
  ttl                 = 1
  # records             = [local.ingress_ip_address]
  records             = ["135.235.10.147"]
  tags = {
    name        = var.kube_dns_prefix
    environment = var.environment
  }
}
# resource "azurerm_dns_a_record" "es_dns_record" {
#   count               = var.create_es_dns_record ? 1 : 0
#   name                = var.es_dns_prefix
#   zone_name           = var.dns_zone_name
#   resource_group_name = var.dns_resource_group_name
#   ttl                 = 1
#   records             = ["135.235.10.147"]
#   tags = {
#     name        = var.es_dns_prefix
#     environment = var.environment
#   }
# }
# resource "azurerm_dns_a_record" "kibana_dns_record" {
#   count               = var.create_kibana_dns_record ? 1 : 0
#   name                = var.kibana_dns_prefix
#   zone_name           = var.dns_zone_name
#   resource_group_name = var.dns_resource_group_name
#   ttl                 = 1
#   records             = ["135.235.10.147"]
#   tags = {
#     name        = var.kibana_dns_prefix
#     environment = var.environment
#   }
# }
# # resource "azurerm_dns_a_record" "backend_dns_record" {
# #   count               = var.create_backend_dns_record ? 1 : 0
# #   name                = var.backend_dns_prefix
# #   zone_name           = var.dns_zone_name
# #   resource_group_name = var.dns_resource_group_name
# #   ttl                 = 1
# #   records             = [local.ingress_ip_address]
# #   tags = {
# #     name        = var.backend_dns_prefix
# #     environment = var.environment
# #   }
# # }


