resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project_name}-${var.environment}-${var.region}"
  location = var.location

  tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project_name
      Subscription = var.subscription
      Region      = var.region
    }
  )
}

resource "azurerm_storage_account" "example" {
  name                     = "st${replace(var.project_name, "-", "")}${var.environment}${replace(var.region, "-", "")}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = azurerm_resource_group.main.tags
}
