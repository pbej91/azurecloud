resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

# Example: Add your Azure resources here
# resource "azurerm_storage_account" "example" {
#   name                     = "st${var.project_name}${var.environment}"
#   resource_group_name      = azurerm_resource_group.main.name
#   location                 = azurerm_resource_group.main.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#
#   tags = azurerm_resource_group.main.tags
# }
