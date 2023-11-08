terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">=3.5.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.78.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.subscription_id
}
