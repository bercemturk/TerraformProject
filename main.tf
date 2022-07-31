                  #####################################################################################################################
                  #####################################################################################################################
locals {
  first_public_key = file("~/.ssh/id_rsa.pub")
}


resource "azurerm_resource_group" "Team2" {
  name     = "Team2-resources"
  location = "East US"
}

resource "azurerm_virtual_network" "Team2" {
  name                = "Team2-network"
  resource_group_name = azurerm_resource_group.Team2.name
  location            = azurerm_resource_group.Team2.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_network_security_group" "Team" {
  name                = "ssh"
  resource_group_name = azurerm_resource_group.Team.name
  location            = azurerm_resource_group.Team.location

  security_rule {
    name                       = "open port"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.Team2.name
  virtual_network_name = azurerm_virtual_network.Team2.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_linux_virtual_machine_scale_set" "Team2" {
  name                = "Team2-vmss"
  resource_group_name = azurerm_resource_group.Team2.name
  location            = azurerm_resource_group.Team2.location
  sku                 = "Standard_F2"
  instances           = 3  # if your account new plz enter 1
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


### Installing MySQL server

resource "azurerm_mysql_server" "Team2" {
  name                = "team2-mysqlserver"
  location            = azurerm_resource_group.Team2.location
  resource_group_name = azurerm_resource_group.Team2.name

  administrator_login          = "mysqladminun"
  administrator_login_password = "H@Sh1CoR3!"

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

