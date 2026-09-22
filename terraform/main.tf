/* resource "random_string" "suffix" {
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

resource "azurerm_cdn_frontdoor_profile" "fd" {
  name                = "fd-${var.project_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Standard_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_endpoint" "site" {
  name                     = "fde-${var.project_name}-${random_string.suffix.result}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id
}

resource "azurerm_cdn_frontdoor_origin_group" "site" {
  name                     = "og-${var.project_name}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }
}

resource "azurerm_cdn_frontdoor_origin" "site" {
  name                          = "origin-${var.project_name}"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.site.id

  enabled                        = true
  host_name                      = azurerm_storage_account.site.primary_web_host
  origin_host_header             = azurerm_storage_account.site.primary_web_host
  http_port                      = 80
  https_port                     = 443
  certificate_name_check_enabled = true

  depends_on = [azurerm_storage_account_static_website.site]
}

resource "azurerm_cdn_frontdoor_route" "site" {
  name                          = "route-${var.project_name}"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.site.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.site.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.site.id]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match       = ["/*"]
  forwarding_protocol     = "HttpsOnly"
  https_redirect_enabled  = true
  link_to_default_domain  = true
} */