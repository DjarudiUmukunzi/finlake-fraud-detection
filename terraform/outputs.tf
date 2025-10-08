output "resource_group" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "storage_account" {
  description = "ADLS Gen2 storage account name"
  value       = azurerm_storage_account.adls.name
}

output "key_vault" {
  description = "Key Vault name"
  value       = azurerm_key_vault.kv.name
}

output "data_factory" {
  description = "Data Factory name"
  value       = azurerm_data_factory.adf.name
}

output "databricks_workspace" {
  description = "Databricks workspace name"
  value       = azurerm_databricks_workspace.dbw.name
}
output "detected_tenant_id" {
  description = "Tenant ID the provider is authenticated against"
  value       = data.azurerm_client_config.current.tenant_id
}

output "detected_subscription_id" {
  description = "Subscription ID the provider is authenticated against"
  value       = data.azurerm_client_config.current.subscription_id
}
