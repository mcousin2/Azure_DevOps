locals {
  access_count = var.keyvault_id == null ? 0 : 1
}

data "azurerm_client_config" "current" {}

# Grant the MSI access to the Azure Key Vault
resource "azurerm_role_assignment" "msi" {
  count                = local.access_count
  principal_id         = azurerm_linux_virtual_machine_scale_set.main.identity[0].principal_id
  role_definition_name = "Reader"
  scope                = var.keyvault_id
}

# Add keyvault policy so that the MSI can read the secrets
resource "azurerm_key_vault_access_policy" "msi" {
  count        = local.access_count
  key_vault_id = var.keyvault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_virtual_machine_scale_set.main.identity[0].principal_id

  secret_permissions = [
    "get",
  ]
}
