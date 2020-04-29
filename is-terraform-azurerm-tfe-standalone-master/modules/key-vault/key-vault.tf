data "azurerm_client_config" "current" {}

resource "random_pet" "kv-name" {
  length = 3
}

resource "azurerm_key_vault" "keyvault" {
  resource_group_name    = var.resource_group_name
  location               = var.location
  name                   = substr(replace(random_pet.kv-name.id, "-", ""), 0, 24)
  tenant_id              = data.azurerm_client_config.current.tenant_id
  enabled_for_deployment = true
  sku_name               = "standard"

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
    # adding IP rules here will allow us to write to the AKV from local Terraform
    ip_rules                   = formatlist("%s/32", var.public_ip_allowlist)
    virtual_network_subnet_ids = [var.subnet_id]
  }

  tags = var.common_tags
}

# Grant access to the calling user to manage things inside the Key Vault
resource "azurerm_key_vault_access_policy" "access" {
  key_vault_id = azurerm_key_vault.keyvault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  key_permissions = [
    "get",
    "List",
    "Update",
    "Restore",
    "Backup",
    "Recover",
    "Delete",
    "Import",
    "Create",
  ]

  secret_permissions = [
    "get",
    "List",
    "Set",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
  ]
  certificate_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Import",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "ManageContacts",
    "DeleteIssuers",
    "SetIssuers",
    "ListIssuers",
    "ManageIssuers",
    "GetIssuers",
  ]
}
