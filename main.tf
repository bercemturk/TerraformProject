resource "azurerm_resource_group" "Team2" {
  name     = "my-resources"
  location = "East US"
}
module "vnet" {
  source              = "Azure/vnet/azurerm"
  resource_group_name = azurerm_resource_group.Team2.name
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]
  
  tags = {
    name        = "Team2"
    environment = "DevOps"
    costcenter  = "it"
  }
  
  depends_on = [azurerm_resource_group.Team2]

}


resource "azurerm_network_security_group" "Team2" {
  name                = "Team2-security-group"
  location            = azurerm_resource_group.Team2.location
  resource_group_name = azurerm_resource_group.example.name
}
# module "vnet" {
#   source              = "Azure/vnet/azurerm"
#   resource_group_name = azurerm_resource_group.Team2.name
#   address_space       = ["10.0.0.0/16"]
#   subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#   subnet_names        = ["subnet1", "subnet2", "subnet3"]
#   depends_on          = [azurerm_resource_group.Team2]


  # subnet_service_endpoints = {
  #   subnet2 = ["Microsoft.Storage", "Microsoft.Sql"],
  #   subnet3 = ["Microsoft.AzureActiveDirectory"]
  # }

  # tags = {
  #   name        = "Team2"
  #   environment = "dev"
  #   costcenter  = "it"
  # }
#}

# resource "azurerm_resource_group" "Team2" {
#   name     = "my-resources"
#   location = "East US"
# }

resource "azurerm_virtual_network" "Team2" {
  name                = "my-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.Team2.location
  resource_group_name = azurerm_resource_group.Team2.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.Team2.name
  virtual_network_name = azurerm_virtual_network.Team2.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "Team2" {
  name                = "my-nic"
  location            = azurerm_resource_group.Team2.location
  resource_group_name = azurerm_resource_group.Team2.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  
  }

}

resource "azurerm_virtual_machine" "Team2" {
  name                  = "my-vm"
  location              = azurerm_resource_group.Team2.location
  resource_group_name   = azurerm_resource_group.Team2.name
  network_interface_ids = [azurerm_network_interface.Team2.id]
  vm_size               = "Standard_B1s"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.5"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage'
    managed_disk_type = "Standard_LRS"
    delete_os_disk_on_termination  = true
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
        name = "Team2"
        environment = "DevOps"
        costcenter  = "it"
  }
  depends_on = [azurerm_resource_group.Team2]
 }
