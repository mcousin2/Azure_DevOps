resource "random_string" "postgres-password" {
  length  = 24
  special = false
}

resource "random_pet" "postgres-name" {
  length    = 3
  separator = ""
}

resource "azurerm_postgresql_server" "main" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = random_pet.postgres-name.id

  sku_name = var.postgres_sku_name

  storage_profile {
    storage_mb            = 5120
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
    auto_grow             = "Enabled"
  }

  administrator_login          = var.postgres_user
  administrator_login_password = random_string.postgres-password.result
  version                      = "9.5"
  ssl_enforcement              = "Enabled"
  tags                         = var.common_tags
}

resource "azurerm_postgresql_database" "main" {
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.main.name
  name                = "tfe_primary"
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_postgresql_virtual_network_rule" "main" {
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.main.name
  subnet_id           = var.subnet_id
  name                = "postgresql-vnet-rule"
  # ignore_missing_vnet_service_endpoint = true
}

# (Optional) allows access to the PaaS from outside the Vnet
resource "azurerm_postgresql_firewall_rule" "public_allow" {
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.main.name
  count               = length(var.public_ip_allowlist)
  name                = format("postgresql-public-%s", count.index)
  start_ip_address    = var.public_ip_allowlist[count.index]
  end_ip_address      = var.public_ip_allowlist[count.index]
}
