variable "rg_name" {
  description = "Name of the Azure Resource Group"
  default     = "rg-finlake-dev"
}

variable "location" {
  description = "Azure region for all resources"
  default     = "East US"
}

variable "sa_prefix" {
  description = "Prefix for the storage account name"
  default     = "finlakeadls"
}

variable "kv_name" {
  description = "Name of the Key Vault"
  default     = "kv-finlake-dev"
}

variable "adf_name" {
  description = "Name of the Azure Data Factory"
  default     = "adf-finlake-dev"
}

variable "dbw_name" {
  description = "Name of the Databricks workspace"
  default     = "databricks-finlake-dev"
}
