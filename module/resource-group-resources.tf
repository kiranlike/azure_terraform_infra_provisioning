resource "azurerm_resource_group" "main_resource_group" {
  name     = var.environment_prefix == "dg6sd3" || var.environment_prefix == "gn2di7" ? var.environment : "${var.environment_prefix}-${var.environment}"
  location = var.resource_location
  tags = {
    name               = "${var.environment_prefix}-${var.environment}"
    environment_prefix = var.environment_prefix
    environment        = var.environment
  }
}
