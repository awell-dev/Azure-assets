resource "azurerm_resource_group" "rg" {
  name     = "AOAI-APIM-Consumption-${random_string.suffix.result}"
  location = var.location
}
