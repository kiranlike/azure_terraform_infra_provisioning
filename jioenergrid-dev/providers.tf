terraform {
  backend "azurerm" {
    resource_group_name  = "prod_tfstate"
    storage_account_name = "datastorage"
    container_name       = "stag"
    key                  = "terraform.tfstate"
  }



  required_providers {
    azurerm = {
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
}
