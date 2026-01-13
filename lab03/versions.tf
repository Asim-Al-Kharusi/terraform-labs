terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state-dev"
    storage_account_name = "tfsa35973"
    container_name       = "tfstate"
    key                  = "observability-dev"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.57.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }
  }
}

provider "azurerm" {
  features {}
}
