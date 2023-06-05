terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.59.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  default_tags = {
    Environment = upper(var.environment)
    OwnerName   = var.owner_name
    OwnerEmail  = var.owner_email
    Project     = var.project
  }
}
