terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.50"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
  cloud {
    organization = "finlake-fraud-detection"       # ← replace this
    workspaces { name = "finlake-infra-dev" }
  }
}

provider "azurerm" {
  features {}

}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

resource "random_id" "suffix" {
  byte_length = 2
}

resource "azurerm_storage_account" "adls" {
  name                     = lower("${var.sa_prefix}${random_id.suffix.hex}")
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled = true
}

resource "azurerm_key_vault" "kv" {
  name                        = var.kv_name
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"

}

resource "azurerm_data_factory" "adf" {
  name                = var.adf_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_databricks_workspace" "dbw" {
  name                = var.dbw_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "premium"
}
