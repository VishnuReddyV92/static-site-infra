terraform {
  required_version = ">= 1.9.0"

  cloud {
    organization = "vvr-org"

    workspaces {
      name = "static-site-prod"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"   # or "~> 5.0.0" if you take on the static_website migration above
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  tenant_id       = var.azure_tenant_id
  use_oidc        = true
}