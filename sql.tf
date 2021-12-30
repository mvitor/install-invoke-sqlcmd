resource "azurerm_sql_server" "sql_server" {
  name                         = "mylab-sqlserver"
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"

  tags = {
    environment = "development"
  }
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "mysqllabstorageaccount"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_sql_database" "sql_database" {
  name                = "mylab-sqldatabase"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  server_name         = azurerm_sql_server.sql_server.name

  tags = {
    environment = "development"
  }
}
resource "azurerm_mssql_server_extended_auditing_policy" "extended_auditing_policy" {
  server_id                               = azurerm_sql_server.sql_server.id
  storage_endpoint                        = azurerm_storage_account.storage_account.primary_blob_endpoint
  storage_account_access_key              = azurerm_storage_account.storage_account.primary_access_key
  storage_account_access_key_is_secondary = true
  retention_in_days                       = 6
}
