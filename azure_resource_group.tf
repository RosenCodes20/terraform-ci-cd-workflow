terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.38.1"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "a2e8abe3-6046-4245-ba2d-32672ba88eda"
}

resource "azurerm_resource_group" "terraformResourceGroupRosen" {
  name     = "${var.resource_group_name}-${random_integer.ri.result}"
  location = var.resource_group_location
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_service_plan" "aasp" {
  name                = "${var.app_service_plan_name}-${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.terraformResourceGroupRosen.name
  location            = azurerm_resource_group.terraformResourceGroupRosen.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "alwa" {
  name                = "${var.app_service_name}-${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.terraformResourceGroupRosen.name
  location            = azurerm_service_plan.aasp.location
  service_plan_id     = azurerm_service_plan.aasp.id

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }

    always_on = false
  }

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.ams.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.amd.name};User ID=${azurerm_mssql_server.ams.administrator_login};Password=${azurerm_mssql_server.ams.administrator_login_password};Trusted_Connection=False; MultipleActiveResultSets=True;"
  }
}

resource "azurerm_mssql_server" "ams" {
  name                         = "${var.sql_server_name}-${random_integer.ri.result}"
  resource_group_name          = azurerm_resource_group.terraformResourceGroupRosen.name
  location                     = azurerm_resource_group.terraformResourceGroupRosen.location
  version                      = "12.0"
  administrator_login          = var.sql_server_admin_login
  administrator_login_password = var.sql_server_admin_password
}


resource "azurerm_mssql_database" "amd" {
  name         = var.sql_database_name
  server_id    = azurerm_mssql_server.ams.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "S0"
  enclave_type = "VBS"
}

resource "azurerm_mssql_firewall_rule" "amfr" {
  name             = var.firewall_rule_name
  server_id        = azurerm_mssql_server.ams.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_app_service_source_control" "aassc" {
  app_id                 = azurerm_linux_web_app.alwa.id
  repo_url               = var.repo_URL
  branch                 = "main"
  use_manual_integration = true
}