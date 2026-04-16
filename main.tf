terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.1.0"
    }
  }
}
provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-user3"
    storage_account_name = "sauser3"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

module "keyvault" {
  source        = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=keyvault/v1.0.0"
  keyvault_name = "kv-user3"
  network_acls  = { bypass = "AzureServices" }
  resource_group = {
    name = "rg-user3"
  location = "northeurope" }
}

module "mssql_server" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=mssql_server/v1.0.0"
  resource_group = {
    name     = "rg-user3"
    location = "northeurope"
  }
  sql_server_admin   = "user3"
  sql_server_name    = "sqlsrv-user3"
  sql_server_version = "12.0"
}

module "application_insights" {
  source                    = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=application_insights/v1.0.0"
  application_insights_name = "ai-user3"
  log_analytics_name        = "la-user3"
  resource_group = {
    name     = "rg-user3"
    location = "northeurope"
  }
}

module "service_plan" {
  source                = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=service_plan/v2.0.0"
  app_service_plan_name = "asp-user3"
  resource_group = {
    name     = "rg-user3"
    location = "northeurope"
  }
  sku_name = "B1"
  tags = {
    owner = "user3"
  }
}

module "managed_identity" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=managed_identity/v1.0.0"
  name   = "mi2-user3"
  resource_group = {
    name     = "rg-user3"
    location = "northeurope"
  }
}

module "app_service" {
  source              = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=app_service/v1.0.0"
  app_service_name    = "as-user3"
  app_service_plan_id = module.service_plan.app_service_plan.id
  # app_settings        = {
  #   ConnectionString =
  #   RazorPagesMovieContext =
  #   SecretKey =
  # }
  identity_client_id  = module.managed_identity.managed_identity_client_id
  identity_id         = module.managed_identity.managed_identity_id
  resource_group = {
    name     = "rg-user3"
    location = "northeurope"
  }
}

module "container_registry" {
  source                  = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=container_registry/v1.0.0"
  container_registry_name = "CR2User3"
  resource_group = {
    name     = "rg-user3"
    location = "northeurope"
  }
}
