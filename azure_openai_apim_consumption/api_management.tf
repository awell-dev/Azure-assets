resource "azurerm_api_management" "aoai" {
  name                = "aoai-${random_string.suffix.result}" # name がホスト名になる ${name}.azure-api.net
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  publisher_name  = var.apim_publisher_name
  publisher_email = var.apim_publisher_email
  sku_name        = "Consumption_0"

  identity {
    type = "SystemAssigned"
  }

  public_network_access_enabled = true

  protocols {
    enable_http2 = true # default: false
  }
}
