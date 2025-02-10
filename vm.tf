terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  cloud {
    organization = "your-spacelift-org"

    workspaces {
      name = "azure-blob-storage"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create Storage Account (Equivalent to S3 in Azure)
resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = false
}

# Create Blob Storage Container (Equivalent to S3 Bucket)
resource "azurerm_storage_container" "container" {
  name                  = "spacelift-container"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

# Outputs
output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}

output "storage_account_primary_key" {
  value     = azurerm_storage_account.storage.primary_access_key
  sensitive = true
}

output "storage_container_url" {
  value = azurerm_storage_container.container.id
}

# Variables
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "resource_group_name" {
  default = "spacelift-rg"
}
variable "location" {
  default = "East US"
}
variable "storage_account_name" {
  default = "spaceliftstorage1234" # Must be globally unique
}
