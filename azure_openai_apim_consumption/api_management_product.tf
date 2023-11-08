resource "azurerm_api_management_product" "gpt" {
  display_name        = "GPT-${random_string.suffix.result}"
  product_id          = "gpt-${random_string.suffix.result}"
  api_management_name = azurerm_api_management.aoai.name
  resource_group_name = azurerm_resource_group.rg.name

  subscription_required = true

  approval_required   = true
  subscriptions_limit = 1000 # プロダクトに紐づけられるサブスクリプション数の上限

  published = true
}

resource "azurerm_api_management_product_api" "gpt_001_gpt_chat_v1" {
  api_name            = azurerm_api_management_api.gpt_chat_v1.name
  product_id          = azurerm_api_management_product.gpt.product_id
  api_management_name = azurerm_api_management.aoai.name
  resource_group_name = azurerm_resource_group.rg.name
}
