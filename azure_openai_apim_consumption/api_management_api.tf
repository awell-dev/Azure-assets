resource "azurerm_api_management_api_version_set" "aoai" {
  name                = "aoai-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.aoai.name
  display_name        = "Azure OpenAI API"
  versioning_scheme   = "Segment" # Segment = path
}


resource "azurerm_api_management_api" "gpt_chat_v1" {
  name                = "gpt_chat_v1"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.aoai.name
  display_name        = "Azure OpenAI API - GPT"

  path = "gpt"

  version        = "v1"
  version_set_id = azurerm_api_management_api_version_set.aoai.id

  revision  = "1"
  api_type  = "http"
  protocols = ["https"]

  subscription_required = true
  subscription_key_parameter_names {
    header = "api-key" # default: Ocp-Apim-Subscription-Key
    query  = "api-key" # default: subscription-key
  }
}



resource "azurerm_api_management_api_operation" "gpt_35_turbo_16k_chat" {

  operation_id        = "gpt_35_turbo_16k_chat"
  api_name            = azurerm_api_management_api.gpt_chat_v1.name
  api_management_name = azurerm_api_management.aoai.name
  resource_group_name = azurerm_resource_group.rg.name

  display_name = "chat-35-turbo-16k"
  method       = "POST"
  url_template = "/gpt-35-turbo-16k"

  request {
    query_parameter {
      name          = "api-version"
      required      = true
      type          = "string"
      default_value = "2023-05-15"
      values = [
        # https://learn.microsoft.com/ja-jp/azure/ai-services/openai/reference#chat-completions
        "2023-05-15",
        "2023-07-01-preview",
        "2023-08-01-preview"
      ]
    }
    header {
      name          = "Content-Type"
      required      = true
      type          = "string"
      default_value = "application/json"
      values        = ["application/json"]
    }
  }
}

resource "azurerm_api_management_api_operation_policy" "gpt_35_turbo_16k_chat" {
  api_name            = azurerm_api_management_api.gpt_chat_v1.name
  api_management_name = azurerm_api_management.aoai.name
  resource_group_name = azurerm_resource_group.rg.name
  operation_id        = azurerm_api_management_api_operation.gpt_35_turbo_16k_chat.operation_id

  xml_content = templatefile("${path.module}/templates/api_operation_policy.xml",
    {
      deploy_name = "${azurerm_cognitive_deployment.gpt_35_turbo_16k.name}",
      backend_url = "${azurerm_cognitive_account.aoai_japaneast.endpoint}openai/deployments/"
    }
  )
}


resource "azurerm_api_management_api_operation" "gpt_35_turbo_chat" {

  operation_id        = "gpt_35_turbo_chat"
  api_name            = azurerm_api_management_api.gpt_chat_v1.name
  api_management_name = azurerm_api_management.aoai.name
  resource_group_name = azurerm_resource_group.rg.name

  display_name = "chat-35-turbo"
  method       = "POST"
  url_template = "/gpt-35-turbo"

  request {
    query_parameter {
      name          = "api-version"
      required      = true
      type          = "string"
      default_value = "2023-05-15"
      values = [
        # https://learn.microsoft.com/ja-jp/azure/ai-services/openai/reference#chat-completions
        "2023-05-15",
        "2023-07-01-preview",
        "2023-08-01-preview"
      ]
    }
    header {
      name          = "Content-Type"
      required      = true
      type          = "string"
      default_value = "application/json"
      values        = ["application/json"]
    }
  }
}

resource "azurerm_api_management_api_operation_policy" "gpt_35_turbo_chat" {
  api_name            = azurerm_api_management_api.gpt_chat_v1.name
  api_management_name = azurerm_api_management.aoai.name
  resource_group_name = azurerm_resource_group.rg.name
  operation_id        = azurerm_api_management_api_operation.gpt_35_turbo_chat.operation_id

  xml_content = templatefile("${path.module}/templates/api_operation_policy.xml",
    {
      deploy_name = "${azurerm_cognitive_deployment.gpt_35_turbo.name}",
      backend_url = "${azurerm_cognitive_account.aoai_japaneast.endpoint}openai/deployments/"
    }
  )
}
