resource "azurerm_virtual_network" "main_virtual_network" {
  name = var.main_virtual_network_name
  address_space = [
    var.main_virtual_network_address_space
  ]
  location            = var.resource_location
  resource_group_name = azurerm_resource_group.main_resource_group.name
  tags = {
    name        = var.main_virtual_network_name
    environment = var.environment
  }
  depends_on = [
    azurerm_resource_group.main_resource_group
  ]
}

resource "azurerm_subnet" "kube_subnet" {
  count                             = var.create_aks ? 1 : 0
  name                              = var.kube_subnet_name
  resource_group_name               = azurerm_resource_group.main_resource_group.name
  virtual_network_name              = var.main_virtual_network_name
  private_endpoint_network_policies = "Enabled"
  address_prefixes = [
    var.kube_subnet_address_space
  ]
  service_endpoints = ["Microsoft.AzureCosmosDB",
                       "Microsoft.Storage"]
  depends_on = [
    azurerm_virtual_network.main_virtual_network
  ]
}

# resource "azurerm_subnet" "redis_subnet" {
#   count                             = var.create_backend_redis || var.create_admin_redis ? 1 : 0
#   name                              = var.redis_subnet_name
#   resource_group_name               = azurerm_resource_group.main_resource_group.name
#   virtual_network_name              = var.main_virtual_network_name
#   private_endpoint_network_policies = "Enabled"
#   address_prefixes = [
#     var.redis_subnet_address_space
#   ]
#   depends_on = [
#     azurerm_virtual_network.main_virtual_network
#   ]
# }



resource "azurerm_subnet" "gateway_subnet" {
  count                             = var.create_vnet_gateway ? 1 : 0
  name                              = var.gateway_subnet_name
  resource_group_name               = azurerm_resource_group.main_resource_group.name
  virtual_network_name              = var.main_virtual_network_name
  private_endpoint_network_policies = "Enabled"
  address_prefixes = [
    var.gateway_subnet_address_space
  ]
  service_endpoints = ["Microsoft.AzureCosmosDB"]
  depends_on = [
    azurerm_virtual_network.main_virtual_network
  ]
}

resource "azurerm_subnet" "postgres_subnet" {
  count                             = var.create_postgres ? 1 : 0
  name                              = var.postgres_subnet_name
  resource_group_name               = azurerm_resource_group.main_resource_group.name
  virtual_network_name              = var.main_virtual_network_name
  private_endpoint_network_policies = "Enabled"
  address_prefixes = [
    var.postgres_subnet_address_space
  ]
  service_endpoints = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
  depends_on = [
    azurerm_virtual_network.main_virtual_network
  ]
}
resource "azurerm_subnet" "eventhub_subnet" {
  count                             = var.create_eventhub ? 1 : 0
  name                              = var.eventhub_subnet_name
  resource_group_name               = azurerm_resource_group.main_resource_group.name
  virtual_network_name              = var.main_virtual_network_name
  private_endpoint_network_policies = "Enabled"
  address_prefixes = [
    var.eventhub_subnet_address_space
  ]
  service_endpoints = ["Microsoft.EventHub"]
  depends_on = [
    azurerm_virtual_network.main_virtual_network
  ]
}
resource "azurerm_network_security_group" "postgres_nsg" {
  count               = var.create_postgres ? 1 : 0
  name                = var.postgres_network_security_group_name
  location            = var.resource_location
  resource_group_name = azurerm_resource_group.main_resource_group.name
  security_rule {
    name                       = "postgres-sr"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }
  lifecycle {
    ignore_changes = [
      security_rule
    ]
  }
  tags = {
    name        = var.postgres_network_security_group_name
    environment = var.environment
  }
  depends_on = [
    azurerm_subnet.postgres_subnet
  ]
}

resource "azurerm_subnet_network_security_group_association" "postgres_nsg_association" {
  count                     = var.create_postgres ? 1 : 0
  subnet_id                 = azurerm_subnet.postgres_subnet[0].id
  network_security_group_id = azurerm_network_security_group.postgres_nsg[0].id
  depends_on = [
    azurerm_network_security_group.postgres_nsg
  ]
}

# resource "azurerm_subnet" "cosmos_db_subnet" {
#   count                             = var.create_cosmos_db ? 1 : 0
#   name                              = var.cosmos_db_subnet_name
#   resource_group_name               = azurerm_resource_group.main_resource_group.name
#   virtual_network_name              = var.main_virtual_network_name
#   private_endpoint_network_policies = "Enabled"
#   service_endpoints                 = ["Microsoft.AzureCosmosDB"]
#   address_prefixes = [
#     var.cosmos_db_subnet_address_space
#   ]
#   depends_on = [
#     azurerm_virtual_network.main_virtual_network
#   ]
# }
resource "azurerm_subnet" "cosmos_db_subnet" {
  count                             = var.create_cosmos_db ? 1 : 0
  name                              = var.cosmos_db_subnet_name
  resource_group_name               = azurerm_resource_group.main_resource_group.name
  virtual_network_name              = var.main_virtual_network_name
  private_endpoint_network_policies = "Enabled"
  address_prefixes = [
    var.cosmos_db_subnet_address_space
  ]
  service_endpoints = ["Microsoft.AzureCosmosDB"]

  # delegation {
  #   name = "Microsoft.AzureCosmosDB/clusters"
  #   service_delegation {
  #     name = "Microsoft.AzureCosmosDB/clusters"
  #     actions = [
  #       "Microsoft.Network/virtualNetworks/subnets/join/action",
  #     ]
  #   }
  # }
  depends_on = [
    azurerm_virtual_network.main_virtual_network
  ]
}
resource "azurerm_network_security_group" "cosmos_db_nsg" {
  count               = var.create_cosmos_db ? 1 : 0
  name                = var.cosmos_db_network_security_group_name
  location            = var.resource_location
  resource_group_name = azurerm_resource_group.main_resource_group.name
  security_rule {
    name                       = "cosmos_db-sr"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }
  tags = {
    name        = var.cosmos_db_network_security_group_name
    environment = var.environment
  }
  lifecycle {
    ignore_changes = [
      security_rule
    ]
  }
  depends_on = [
    azurerm_subnet.cosmos_db_subnet
  ]
}
resource "azurerm_subnet_network_security_group_association" "cosmos_db_nsg_association" {
  count                     = var.create_cosmos_db ? 1 : 0
  subnet_id                 = azurerm_subnet.cosmos_db_subnet[0].id
  network_security_group_id = azurerm_network_security_group.cosmos_db_nsg[0].id
  depends_on = [
    azurerm_network_security_group.cosmos_db_nsg
  ]
}