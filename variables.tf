variable "resource_group_name" {
  description = "The name of the resource group where the resources will be created."
  type        = string
}

variable "resource_group_location" {
  description = "The Azure region where the resource group will be created."
  type        = string
}

variable "app_service_plan_name" {
  description = "The name of the App Service Plan."
  type        = string
}

variable "app_service_name" {
  description = "value of the App Service name."
  type        = string
}

variable "sql_server_name" {
  description = "value of the SQL Server name."
  type        = string
}

variable "sql_database_name" {
  description = "The name of the SQL Database."
  type        = string
}

variable "sql_server_admin_login" {
  description = "The administrator login for the SQL Server."
  type        = string
}

variable "sql_server_admin_password" {
  description = "The administrator password for the SQL Server."
  type        = string
}

variable "firewall_rule_name" {
  description = "The name of the SQL Server firewall rule."
  type        = string

}

variable "repo_URL" {
  description = "The URL of the repository to deploy to the App Service."
  type        = string
}