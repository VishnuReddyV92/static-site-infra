resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project_name}-${var.environment}"
  location = var.location
}

resource "azurerm_storage_account" "site" {
  name                     = "st${var.project_name}${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version          = "TLS1_2"
}

resource "azurerm_storage_account_static_website" "site" {
  storage_account_id = azurerm_storage_account.site.id
  index_document      = "index.html"
  error_404_document  = "index.html"
}

resource "azurerm_cdn_profile" "cdn" {
  name                = "cdn-${var.project_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location             = "global"
  sku                 = "Standard_Microsoft"
}

resource "azurerm_cdn_endpoint" "site" {
  name                = "cdn-${var.project_name}-${random_string.suffix.result}"
  profile_name        = azurerm_cdn_profile.cdn.name
  location            = azurerm_cdn_profile.cdn.location
  resource_group_name = azurerm_resource_group.rg.name

  origin_host_header = azurerm_storage_account.site.primary_web_host

  origin {
    name      = "storage-origin"
    host_name = azurerm_storage_account.site.primary_web_host
  }

  is_https_allowed = true

  depends_on = [azurerm_storage_account_static_website.site]
}