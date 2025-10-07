terraform {
  required_providers {
    azurerm = { source = "hashicorp/azurerm" }
  }
  cloud {
    organization = "YOUR_TERRAFORM_ORG"          # Terraform Cloud org
    workspaces { name = "finlake-dev" }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

resource "random_id" "suffix" { byte_length = 2 }

resource "azurerm_storage_account" "adls" {
  name                     = lower("${var.sa_prefix}${random_id.suffix.hex}")
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
}

resource "azurerm_key_vault" "kv" {
  name                        = var.kv_name
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_enabled         = true
}
# add databricks workspace & data factory resources (use azurerm_databricks_workspace & azurerm_data_factory)
data "azurerm_client_config" "current" {}
