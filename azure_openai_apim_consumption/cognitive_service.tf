resource "azurerm_cognitive_account" "aoai_japaneast" {
  name                = "japaneast-${random_string.suffix.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  kind     = "OpenAI"
  sku_name = "S0"

  # エンドポイントのサブドメインを設定
  # 大文字が含まれる場合、自動的に小文字に変換される。大文字が含まれる場合 Apply 時に毎回変更として扱われ Replase が発生するため lower で小文字に変換する
  custom_subdomain_name = lower("japaneast-${random_string.suffix.result}")

  # アクセスキーでのアクセスを無効化
  local_auth_enabled = false

  # アウトバンドネットワークアクセスを制限するか
  outbound_network_access_restricted = true

  # パブリックネットワークアクセスを有効化
  public_network_access_enabled = true
}

resource "azurerm_cognitive_deployment" "gpt_35_turbo_16k" {
  name                 = "gpt-3_5-turbo_16k-${random_string.suffix.result}"
  cognitive_account_id = azurerm_cognitive_account.aoai_japaneast.id

  # コマンドで利用可能なモデルを確認
  # # az cognitiveservices model list -l japaneast --query "[?kind=='OpenAI'].{Format:model.format, Name:model.name, Version:model.version, SkuName:skuName, LifecycleStatus:model.lifecycleStatus, IsDefaultVersion:model.isDefaultVersion}" -o table
  model {
    format  = "OpenAI"
    name    = "gpt-35-turbo-16k"
    version = "0613"
  }

  scale {
    type = "Standard"
  }
}

resource "azurerm_cognitive_deployment" "gpt_35_turbo" {
  name                 = "gpt-3_5-turbo-${random_string.suffix.result}"
  cognitive_account_id = azurerm_cognitive_account.aoai_japaneast.id

  # コマンドで利用可能なモデルを確認
  # az cognitiveservices model list -l japaneast --query "[].{Format:model.format, Name:model.name, Version:model.version, SkuName:skuName, LifecycleStatus:model.lifecycleStatus, IsDefaultVersion:model.isDefaultVersion}" -o table
  model {
    format  = "OpenAI"
    name    = "gpt-35-turbo"
    version = "0613"
  }

  scale {
    type = "Standard"
  }
}
