output "azurerm_resource_group_location" {
  value = azurerm_resource_group.team2.location
}

output "resource_group_name" {
  value = azurerm_resource_group.team2.name
}

output "vnet_id" {
  value = azurerm_virtual_network.team2.id
}

output "vnet_name" {
  value = azurerm_virtual_network.team2.name
}

output "subnets_id" {
  value = azurerm_virtual_network.team2.subnet[*].id
}