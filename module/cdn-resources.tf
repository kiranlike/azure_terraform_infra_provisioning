# resource "azurerm_cdn_profile" "cdn_profile" {
#   count                    = var.create_consumerweb_storage_account || var.create_operatorweb_storage_account || var.create_webview_storage_account || var.create_consumerweb_storage_account || var.create_adminweb_storage_account || var.create_partnerweb_storage_account ? 1 : 0
#   name                     = "${var.environment_prefix}-${var.cdn_profile_name}"
#   location                 = "Global"
#   resource_group_name      = azurerm_resource_group.main_resource_group.name
#   # response_timeout_seconds = 120
#   sku                      = var.cdn_profile_sku
#   tags = {
#     name        = "${var.environment_prefix}-${var.cdn_profile_name}"
#     environment = var.environment
#   }
# }

resource "azurerm_cdn_frontdoor_profile" "cdn_profile" {
  count                    = var.create_consumerweb_storage_account || var.create_operatorweb_storage_account || var.create_webview_storage_account || var.create_cpoweb_storage_account || var.create_adminweb_storage_account || var.create_partnerweb_storage_account ? 1 : 0
  name                     = "${var.environment_prefix}-${var.cdn_profile_name}"
  resource_group_name      = azurerm_resource_group.main_resource_group.name
  response_timeout_seconds = 120
  sku_name                 = var.cdn_profile_sku
  tags = {
    name        = "${var.environment_prefix}-${var.cdn_profile_name}"
    environment = var.environment
  }
}

# resource "azurerm_cdn_frontdoor_endpoint" "operatorweb_cdn_endpoint" {
#   count                    = var.create_operatorweb_storage_account ? 1 : 0
#   name                     = "${var.environment_prefix}-${var.operatorweb_cdn_endpoint_name}"
#   cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.cdn_profile[0].id
#   enabled                  = true
#   tags = {
#     name        = "${var.environment_prefix}-${var.operatorweb_cdn_endpoint_name}"
#     environment = var.environment
#   }
# }



# ------------------------------------------------
# Comsumer  resources
# ------------------------------------------------

resource "azurerm_cdn_frontdoor_endpoint" "consumerweb_cdn_endpoint" {
  count                    = var.create_consumerweb_storage_account ? 1 : 0
  name                     = "${var.environment_prefix}-${var.consumerweb_cdn_endpoint_name}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.cdn_profile[0].id
  enabled                  = true
  tags = {
    name        = "${var.environment_prefix}-${var.consumerweb_cdn_endpoint_name}"
    environment = var.environment
  }
}

resource "azurerm_cdn_frontdoor_origin_group" "consumerweb_cdn_origin_group" {
  count                                                     = var.create_consumerweb_storage_account ? 1 : 0
  name                                                      = "webcdnorigingroup"
  cdn_frontdoor_profile_id                                  = azurerm_cdn_frontdoor_profile.cdn_profile[0].id
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 0
  session_affinity_enabled                                  = false
  load_balancing {
    additional_latency_in_milliseconds = 0
    sample_size                        = 4
    successful_samples_required        = 2
  }
}

resource "azurerm_cdn_frontdoor_origin" "consumerweb_cdn_origin" {
  count                          = var.create_consumerweb_storage_account ? 1 : 0
  name                           = replace(var.consumerweb_dns_prefix, ".", "-")
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.consumerweb_cdn_origin_group[0].id
  enabled                        = true
  certificate_name_check_enabled = false
  host_name                      = azurerm_storage_account.consumerweb_storage_account[0].primary_web_host
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = "${var.environment_prefix}${var.consumerweb_storage_account_name}.z29.web.core.windows.net"
  priority                       = 1
  weight                         = 1000
}

resource "azurerm_cdn_frontdoor_rule_set" "consumerweb_cdn_rule_set" {
  count                    = var.create_consumerweb_storage_account ? 1 : 0
  name                     = "cdnruleset"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.cdn_profile[0].id
}


resource "azurerm_cdn_frontdoor_custom_domain" "consumerweb_cdn_endpoint_custom_domain" {
  count                    = var.create_consumerweb_storage_account ? 1 : 0
  name            = replace(var.consumerweb_dns_prefix, ".", "-")
  # name                      = "${var.environment_prefix}-${var.consumerweb_cdn_endpoint_name}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.cdn_profile[0].id
  tls {
    certificate_type    = "ManagedCertificate"
    minimum_tls_version = "TLS12"
  }
  host_name = "${var.consumerweb_dns_prefix}.${var.dns_zone_name}"
  depends_on = [
    azurerm_cdn_frontdoor_endpoint.consumerweb_cdn_endpoint
  ]
}

resource "azurerm_cdn_frontdoor_route" "consumerweb_cdn_route" {
  count                         = var.create_consumerweb_storage_account ? 1 : 0
  name                          = "webcdnroute"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.consumerweb_cdn_endpoint[0].id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.consumerweb_cdn_origin_group[0].id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.consumerweb_cdn_origin[0].id]
  cdn_frontdoor_rule_set_ids    = [azurerm_cdn_frontdoor_rule_set.consumerweb_cdn_rule_set[0].id]
  enabled                       = true
  forwarding_protocol           = "MatchRequest"
  https_redirect_enabled        = true
  patterns_to_match             = ["/*"]
  supported_protocols           = ["Http", "Https"]
  cdn_frontdoor_custom_domain_ids = [
    azurerm_cdn_frontdoor_custom_domain.consumerweb_cdn_endpoint_custom_domain[0].id
  ]
  lifecycle {
    ignore_changes = [
      cdn_frontdoor_custom_domain_ids
    ]
  }
  cache {
    compression_enabled           = true
    content_types_to_compress     = var.content_types_to_compress
    query_string_caching_behavior = "IgnoreQueryString"
    query_strings                 = []
  }
  link_to_default_domain = true
}

resource "azurerm_cdn_frontdoor_custom_domain_association" "consumerweb_cdn_custom_domain_association" {
  count                          = var.create_consumerweb_storage_account ? 1 : 0
  cdn_frontdoor_custom_domain_id = azurerm_cdn_frontdoor_custom_domain.consumerweb_cdn_endpoint_custom_domain[0].id
  cdn_frontdoor_route_ids        = [azurerm_cdn_frontdoor_route.consumerweb_cdn_route[0].id]
}


# ------------------------------------------------
# Operator  resources
# ------------------------------------------------

resource "azurerm_cdn_frontdoor_endpoint" "operatorweb_cdn_endpoint" {
  count                    = var.create_operatorweb_storage_account ? 1 : 0
  name                     = "${var.environment_prefix}-${var.operatorweb_cdn_endpoint_name}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.cdn_profile[0].id
  enabled                  = true
  tags = {
    name        = "${var.environment_prefix}-${var.operatorweb_cdn_endpoint_name}"
    environment = var.environment
  }
}

resource "azurerm_cdn_frontdoor_origin_group" "operatorweb_cdn_origin_group" {
  count                                                     = var.create_operatorweb_storage_account ? 1 : 0
  name                                                      = "webcdnorigingroup"
  cdn_frontdoor_profile_id                                  = azurerm_cdn_frontdoor_profile.cdn_profile[0].id
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 0
  session_affinity_enabled                                  = false
  load_balancing {
    additional_latency_in_milliseconds = 0
    sample_size                        = 4
    successful_samples_required        = 2
  }
}

resource "azurerm_cdn_frontdoor_origin" "operatorweb_cdn_origin" {
  count                          = var.create_operatorweb_storage_account ? 1 : 0
  # name                           = "${var.environment_prefix}-operator-energrid"
  name                           = replace(var.operatorweb_dns_prefix, ".", "-")
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.operatorweb_cdn_origin_group[0].id
  enabled                        = true
  certificate_name_check_enabled = false
  host_name                      = azurerm_storage_account.operatorweb_storage_account[0].primary_web_host
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = "${var.environment_prefix}${var.operatorweb_storage_account_name}.z29.web.core.windows.net"
  priority                       = 1
  weight                         = 1000
}

resource "azurerm_cdn_frontdoor_rule_set" "operatorweb_cdn_rule_set" {
  count                    = var.create_operatorweb_storage_account ? 1 : 0
  name                     = "webcdnruleset"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.cdn_profile[0].id
}


resource "azurerm_cdn_frontdoor_custom_domain" "operatorweb_cdn_endpoint_custom_domain" {
  count                    = var.create_operatorweb_storage_account ? 1 : 0
  # name                      = "${var.environment_prefix}-${var.operatorweb_cdn_endpoint_name}"
  name            = replace(var.operatorweb_dns_prefix, ".", "-")
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.cdn_profile[0].id
  tls {
    certificate_type    = "ManagedCertificate"
    minimum_tls_version = "TLS12"
  }
  host_name = "${var.operatorweb_dns_prefix}.${var.dns_zone_name}"
  depends_on = [
    azurerm_cdn_frontdoor_endpoint.operatorweb_cdn_endpoint
  ]
}

resource "azurerm_cdn_frontdoor_route" "operatorweb_cdn_route" {
  count                         = var.create_operatorweb_storage_account ? 1 : 0
  name                          = "operatorwebcdnroute"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.operatorweb_cdn_endpoint[0].id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.operatorweb_cdn_origin_group[0].id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.operatorweb_cdn_origin[0].id]
  cdn_frontdoor_rule_set_ids    = [azurerm_cdn_frontdoor_rule_set.operatorweb_cdn_rule_set[0].id]
  enabled                       = true
  forwarding_protocol           = "MatchRequest"
  https_redirect_enabled        = true
  patterns_to_match             = ["/*"]
  supported_protocols           = ["Http", "Https"]
  cdn_frontdoor_custom_domain_ids = [
    azurerm_cdn_frontdoor_custom_domain.operatorweb_cdn_endpoint_custom_domain[0].id
  ]
  lifecycle {
    ignore_changes = [
      cdn_frontdoor_custom_domain_ids
    ]
  }
  cache {
    compression_enabled           = true
    content_types_to_compress     = var.content_types_to_compress
    query_string_caching_behavior = "IgnoreQueryString"
    query_strings                 = []
  }
  link_to_default_domain = true
}

resource "azurerm_cdn_frontdoor_custom_domain_association" "operatorweb_cdn_custom_domain_association" {
  count                          = var.create_operatorweb_storage_account ? 1 : 0
  cdn_frontdoor_custom_domain_id = azurerm_cdn_frontdoor_custom_domain.operatorweb_cdn_endpoint_custom_domain[0].id
  cdn_frontdoor_route_ids        = [azurerm_cdn_frontdoor_route.operatorweb_cdn_route[0].id]
}
