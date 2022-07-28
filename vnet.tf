# Create a resource group
resource "azurerm_resource_group" "Team2" {
  name     = "Team2-resources"
  location = "East US"
}
resource "azurerm_network_security_group" "Team2" {
  name                = "Team2-security-group"
  location            = azurerm_resource_group.Team2.location
  resource_group_name = azurerm_resource_group.Team2.name
}
module "vnet" {
  source              = "Azure/vnet/azurerm"
  resource_group_name = azurerm_resource_group.Team2.name
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]
  depends_on          = [azurerm_resource_group.Team2]

  subnet_service_endpoints = {
    subnet2 = ["Microsoft.Storage", "Microsoft.Sql"],
    subnet3 = ["Microsoft.AzureActiveDirectory"]
  }

  tags = {
    name        = "Team2"
    environment = "dev"
    costcenter  = "it"
  }
}
