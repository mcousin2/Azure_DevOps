resource "azurerm_key_vault_secret" "secrets" {
  key_vault_id = azurerm_key_vault.keyvault.id
  count        = length(var.secrets)
  name         = var.secrets[count.index].name
  content_type = var.secrets[count.index].content_type
  value        = var.secrets[count.index].value

  # Access must be granted before writing secrets
  depends_on = [azurerm_key_vault_access_policy.access]
}
