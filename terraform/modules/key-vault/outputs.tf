output "keyvault" {
  description = "Key vault secrets configuration."
  value = {
    id   = azurerm_key_vault.keyvault.id
    name = azurerm_key_vault.keyvault.name
  }
}
