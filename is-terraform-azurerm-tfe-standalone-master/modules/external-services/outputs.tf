output "object_storage_config" {
  description = "Object storage configuration."
  value = {
    account_name = azurerm_storage_account.main.name
    account_key  = azurerm_storage_account.main.primary_access_key
    container    = azurerm_storage_container.main.name
  }
}

output "postgres_config" {
  description = "Database storage configuration."
  value = {
    dbname       = azurerm_postgresql_database.main.name
    netloc       = "${azurerm_postgresql_server.main.fqdn}:5432"
    user         = "${azurerm_postgresql_server.main.administrator_login}@${azurerm_postgresql_server.main.name}"
    password     = azurerm_postgresql_server.main.administrator_login_password
    extra_params = "sslmode=require"
  }
}
