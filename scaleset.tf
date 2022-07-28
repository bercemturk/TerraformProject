locals {
  first_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCtjrl6evUosX8dgR99iGNa18vHHwhvKb7p6ap6LWh1lXfWVLEwi092zdlViDwpaAgDEcCn5cUkSYIjSKkBpA3JbNf8hcBWt4LygSqfT1Oab3bAzZCDS8pJomHc4LfF8PHZQEUmLJ7FZ4AT3+t6kIcAnvzJ92G9LWimK53iSIPboXnKHMoVxOZV6g5i+UpAUPdPVDSNI6gqVRkGmv9FV+7Wd97FeerdIJYgoZh1ByRWBENQKowqtcXctH+9FVSLKoFI1nfl6hK9JQTiIO8fT83lZHDKHLwdh1bDy5YJ1K9JfFqFLM9IAk4T+5IO3SGrn/J7NiVqcOgk8q0K20WoMteV omar@cc-f6bdb78c-7f646f9788-m6mzx"
}

# resource "azurerm_resource_group" "Team2" {
#   name     = "my-resources"
#   location = "East US"
# }

# resource "azurerm_virtual_network" "Team2" {
#   name                = "Team2-network"
#   resource_group_name = azurerm_resource_group.Team2.name
#   location            = azurerm_resource_group.Team2.location
#   address_space       = ["10.0.0.0/16"]
#}

# resource "azurerm_subnet" "internal" {
#   name                 = "internal"
#   resource_group_name  = azurerm_resource_group.Team2.name
#   virtual_network_name = azurerm_virtual_network.Team2.name
#   address_prefixes     = ["10.0.2.0/24"]
#}

resource "azurerm_linux_virtual_machine_scale_set" "Team2" {
  name                = "Team2-vmss"
  resource_group_name = azurerm_resource_group.Team2.name
  location            = azurerm_resource_group.Team2.location
  sku                 = "Standard_F2"
  instances           = 1
  admin_username      = "adminuser"

  admin_ssh_key {
    username   = "adminuser"
    public_key = local.first_public_key
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
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

