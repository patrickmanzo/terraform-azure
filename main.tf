terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# terraform {
  // backend "azurerm" {
  //   resource_group_name  = "tf_state"
  //   storage_account_name = "tfstate019"
  //   container_name       = "tfstate"
  //   key                  = "terraform.tfstate"
  // }

# Create a Resource Group
# resource "azurerm_resource_group" "resourcegroup" {
#  name     = var.rsgname
#  location = var.resource_group_location