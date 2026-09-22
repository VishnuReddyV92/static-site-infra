output "storage_account_name" {
  value = azurerm_storage_account.site.name
}
/*
output "static_website_url" {
  value = azurerm_storage_account.site.primary_web_endpoint
}

output "cdn_endpoint_url" {
  value = "https://${azurerm_cdn_frontdoor_endpoint.site.host_name}"
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
*/