# 1. Definição dos Providers
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfunianchieta001" # Nome único
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# 2. Grupo de Recursos - O "container" lógico
resource "azurerm_resource_group" "aula_rg" {
  name     = "rg-aula-terraform-cd"
  location = "Canada Central"
}

# 3. Plano de Serviço (F1 é a camada gratuita/Free)
resource "azurerm_service_plan" "aula_plan" {
  name                = "asp-aula-site"
  resource_group_name = azurerm_resource_group.aula_rg.name
  location            = azurerm_resource_group.aula_rg.location
  os_type             = "Linux"
  sku_name            = "F1" 
}

# 4. O Web App propriamente dito
resource "azurerm_linux_web_app" "aula_webapp" {
  name                = "webapp-unianchieta-arq-cloud" # Nome deve ser ÚNICO na Azure
  resource_group_name = azurerm_resource_group.aula_rg.name
  location            = azurerm_service_plan.aula_plan.location
  service_plan_id     = azurerm_service_plan.aula_plan.id

  site_config {
    application_stack {
      node_version = "18-lts"
    }
  }
}