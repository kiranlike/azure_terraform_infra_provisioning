
resource "azurerm_public_ip" "vnet_gateway_ip" {
  count               = var.create_vnet_gateway ? 1 : 0
  name                = var.vnet_gateway_ip_name
  location            = var.resource_location
  resource_group_name = azurerm_resource_group.main_resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard" # TODO: change to "Standard"
  tags = {
    name        = var.vnet_gateway_ip_name
    environment = var.environment
  }
  depends_on = [
    azurerm_resource_group.main_resource_group
  ]
}

resource "azurerm_virtual_network_gateway" "vnet_gateway" {
  count               = var.create_vnet_gateway ? 1 : 0
  name                = var.vnet_gateway_name
  location            = var.resource_location
  resource_group_name = azurerm_resource_group.main_resource_group.name
  type                = var.vnet_gateway_type
  vpn_type            = var.vnet_gateway_vpn_type
  generation          = var.vnet_gateway_generation
  active_active       = false
  enable_bgp          = false
  sku                 = var.vnet_gateway_sku
  ip_configuration {
    name                          = var.vnet_gateway_ip_configuration_name
    public_ip_address_id          = azurerm_public_ip.vnet_gateway_ip[0].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway_subnet[0].id
  }
  vpn_client_configuration {
    address_space = [
      var.gateway_client_address_space
    ]
    root_certificate {
      name             = var.vnet_gateway_root_certificate_name
      public_cert_data = var.vnet_gateway_root_certificate_public_cert_data
    }
  }
    custom_route {
    address_prefixes = []
  }

  tags = {
    name        = var.vnet_gateway_name
    environment = var.environment
  }
  depends_on = [
    azurerm_resource_group.main_resource_group,
    azurerm_subnet.gateway_subnet,
    azurerm_public_ip.vnet_gateway_ip
  ]
}

