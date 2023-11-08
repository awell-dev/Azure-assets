resource "azurerm_api_management_logger" "application_insights" {
  name                = "apim-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.aoai.name

  application_insights {
    instrumentation_key = azurerm_application_insights.apim.instrumentation_key
  }
}

resource "azurerm_api_management_api_diagnostic" "gpt_chat_v1" {
  identifier               = "applicationinsights"
  resource_group_name      = azurerm_resource_group.rg.name
  api_management_name      = azurerm_api_management.aoai.name
  api_name                 = azurerm_api_management_api.gpt_chat_v1.name
  api_management_logger_id = azurerm_api_management_logger.application_insights.id

  sampling_percentage = 100

  always_log_errors = true
  log_client_ip     = true

  http_correlation_protocol = "W3C"
  verbosity                 = "verbose" # ログレベル: error, information, verbose

  frontend_request {
    headers_to_log = ["Content-Type", "X-Forwarded-For", "Referer", "User-Agent", "api-key"]
    data_masking {
      headers {
        mode  = "Mask"
        value = "api-key"
      }
    }

    body_bytes = 8192 # max 8192
  }

  frontend_response {
    body_bytes = 8192 # max 8192
  }
}
