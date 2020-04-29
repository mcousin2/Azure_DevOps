resource "random_pet" "sa-name" {
  length    = 3
  separator = ""
}

resource "azurerm_storage_account" "main" {
  resource_group_name      = var.resource_group_name
  location                 = var.location
  name                     = substr(random_pet.sa-name.id, 0, 24)
  account_tier             = var.storage_account.tier
  account_replication_type = var.storage_account.type

  # VNet integration
  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = [var.subnet_id]
    # (Optional) allows access to the PaaS from outside the Vnet
    ip_rules = var.public_ip_allowlist
  }

  tags = var.common_tags
}

resource "azurerm_storage_container" "main" {
  storage_account_name  = azurerm_storage_account.main.name
  name                  = "tfe-state"
  container_access_type = "private"
}
