output "apim_endpoint" {
  value = azurerm_api_management.aoai.gateway_url
}

output "apim_url_gpt_35_turbo_chat" {
  value = "${azurerm_api_management.aoai.gateway_url}/${azurerm_api_management_api.gpt_chat_v1.path}/${azurerm_api_management_api.gpt_chat_v1.version}${azurerm_api_management_api_operation.gpt_35_turbo_chat.url_template}?api-version=2023-05-15"
}

output "apim_url_gpt_35_turbo_16k_chat" {
  value = "${azurerm_api_management.aoai.gateway_url}/${azurerm_api_management_api.gpt_chat_v1.path}/${azurerm_api_management_api.gpt_chat_v1.version}${azurerm_api_management_api_operation.gpt_35_turbo_16k_chat.url_template}?api-version=2023-05-15"
}

output "subscription_primary_key" {
  sensitive = true
  value     = azurerm_api_management_subscription.example.primary_key
}

output "subscription_secondary_key" {
  sensitive = true
  value     = azurerm_api_management_subscription.example.secondary_key
}
