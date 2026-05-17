output "resource_group_id" {
  description = "The ID of the created resource group"
  value       = azurerm_resource_group.main.id
}

output "resource_group_name" {
  description = "The name of the created resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "The location of the created resource group"
  value       = azurerm_resource_group.main.location
}

output "storage_account_id" {
  description = "The ID of the created storage account"
  value       = azurerm_storage_account.example.id
}

output "storage_account_name" {
  description = "The name of the created storage account"
  value       = azurerm_storage_account.example.name
}
