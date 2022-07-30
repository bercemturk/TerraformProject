locals {
  first_public_key = file("~/.ssh/id_rsa.pub")
}


resource "azurerm_resource_group" "Team2" {
  name     = "Team2-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "Team2" {
  name                = "Team2-network"
  resource_group_name = azurerm_resource_group.Team2.name
  location            = azurerm_resource_group.Team2.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.Team2.name
  virtual_network_name = azurerm_virtual_network.Team2.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_linux_virtual_machine_scale_set" "Team2" {
  name                = "Team2-vmss"
  resource_group_name = azurerm_resource_group.Team2.name
  location            = azurerm_resource_group.Team2.location
  sku                 = "Standard_F2"
  instances           = 3 
  admin_username      = "adminuser"

  admin_ssh_key {
    username   = "adminuser"
    public_key = local.first_public_key
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.5"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"

  }
  
  network_interface {
    name    = "Team2"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.internal.id
    }
  }
}
