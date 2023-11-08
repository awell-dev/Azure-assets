resource "azurerm_api_management_subscription" "example" {
  display_name        = "GPT"
  subscription_id     = "ExampleSubscriptionId"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.aoai.name

  product_id = azurerm_api_management_product.gpt.id
  state      = "active" # active, suspended, expired, submitted, rejected, cancelled

  allow_tracing = false
}
