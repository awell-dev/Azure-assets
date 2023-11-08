resource "azurerm_role_assignment" "aoai_japaneast" {
  scope = azurerm_cognitive_account.aoai_japaneast.id

  # az コマンドで利用可能なロールを確認
  # az role definition list --custom-role-only false --output table --query '[].{roleName:roleName, roleType:roleType}' | grep Cognitive
  role_definition_name = "Cognitive Services User"

  principal_id = azurerm_api_management.aoai.identity[0].principal_id
}
