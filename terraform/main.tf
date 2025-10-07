terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.50"
    }
  }
  cloud {
    organization = "YOUR_TERRAFORM_ORG"
    workspaces { name = "finlake-dev" }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-finlake-dev"
  location = "East US"
}

resource "azurerm_storage_account" "adls" {
  name                     = "finlakeadls${random_id.suffix.hex}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
}

resource "azurerm_key_vault" "kv" {
  name                = "kv-finlake-dev"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

resource "azurerm_data_factory" "adf" {
  name                = "adf-finlake-dev"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_databricks_workspace" "dbw" {
  name                = "dbw-finlake-dev"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "premium"
}

resource "random_id" "suffix" {
  byte_length = 2
}

data "azurerm_client_config" "current" {}
