output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
output "storage_account_name" {
  value = azurerm_storage_account.adls.name
}
output "key_vault_name" {
  value = azurerm_key_vault.kv.name
}
output "adf_name" {
  value = azurerm_data_factory.adf.name
}
output "databricks_workspace_name" {
  value = azurerm_databricks_workspace.dbw.name
}
