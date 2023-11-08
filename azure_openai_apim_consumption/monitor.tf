resource "azurerm_monitor_action_group" "health_alert" {
  name                = "health-alert-group-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = random_string.suffix.result

  email_receiver {
    name          = var.health_alert_user_name
    email_address = var.health_alert_user_email_address
  }
}

# リソースの正常性
resource "azurerm_monitor_activity_log_alert" "resource" {
  name                = "resouce-health-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name

  scopes = [
    azurerm_cognitive_account.aoai_japaneast.id,
    azurerm_api_management.aoai.id
  ]

  criteria {
    category = "ResourceHealth"
    resource_health {
      current  = ["Available", "Degraded", "Unavailable", "Unknown"]
      previous = ["Available", "Degraded", "Unavailable", "Unknown"]
      reason   = ["PlatformInitiated", "UserInitiated", "Unknown"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.health_alert.id
  }
}

data "azurerm_subscription" "current" {}

# サービスの正常性
resource "azurerm_monitor_activity_log_alert" "service" {
  name                = "service-health-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name

  scopes = [data.azurerm_subscription.current.id]

  criteria {
    category = "ServiceHealth"
    service_health {
      events    = ["Incident", "Maintenance", "Informational", "ActionRequired", "Security"]
      locations = ["Japan East"]
      services  = ["Azure OpenAI Service", "API Management", "Application Insights"]
    }
  }
}

# API Management の application insights 設定
resource "azurerm_application_insights" "apim" {
  name                = "apim-${random_string.suffix.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  application_type = "other"

  retention_in_days = 90
}
