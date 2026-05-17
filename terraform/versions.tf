terraform {
  required_version = ">= 1.6.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.75"
    }
  }

  backend "azurerm" {
    # Backend config values are passed via -backend-config flags during terraform init
    # See .github/workflows/terraform-deploy.yml for how these are provided
    # Required values: storage_account_name, container_name, key, access_key
  }
}

provider "azurerm" {
  features {}
  
  use_oidc = true
  skip_provider_registration = false
}
