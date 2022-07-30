#Create resource group
resource "azurerm_resource_group" "team2" {
  name     = var.rs_name
  location = var.rs_location
}

#Create Security Group
resource "azurerm_network_security_group" "team2" {
  name                = var.security_group
  location            = azurerm_resource_group.team2.location
  resource_group_name = azurerm_resource_group.team2.name

  security_rule {
    name                       = "main"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = var.tags
}
resource "azurerm_virtual_network" "team2" {
  name                = var.vnet_name
  location            = azurerm_resource_group.team2.location
  resource_group_name = azurerm_resource_group.team2.name
  address_space       = var.vnet_cidr

  subnet {
    name           = "subnet1"
    address_prefix = var.public_subnet1
    security_group = azurerm_network_security_group.team2.id
  }

  subnet {
    name           = "subnet2"
    address_prefix = var.public_subnet2
    security_group = azurerm_network_security_group.team2.id
  }

  subnet {
    name           = "subnet3"
    address_prefix = var.public_subnet3
    security_group = azurerm_network_security_group.team2.id
  }
  tags = var.tags
}

resource "azurerm_route_table" "team2" {
  name                          = "team2-route-table"
  location                      = azurerm_resource_group.team2.location
  resource_group_name           = azurerm_resource_group.team2.name
  disable_bgp_route_propagation = false

  route {
    name           = "route1"
    address_prefix = var.public_subnet1
    next_hop_type  = "VnetLocal"
  }
  route {
    name           = "route2"
    address_prefix = var.public_subnet2
    next_hop_type  = "VnetLocal"
  }
  route {
    name           = "route3"
    address_prefix = var.public_subnet3
    next_hop_type  = "VnetLocal"
  }
  tags = var.tags
}