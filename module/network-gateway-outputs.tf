output "vnet_gateway" {
  value = {
    # id        = var.create_vnet_gateway ? azurerm_virtual_network_gateway.vnet_gateway[0].id : null
    public_ip = var.create_vnet_gateway ? azurerm_public_ip.vnet_gateway_ip[0].ip_address : null
  }
  depends_on = [
    azurerm_public_ip.vnet_gateway_ip
  ]
}
