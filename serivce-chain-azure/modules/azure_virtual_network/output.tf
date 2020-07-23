output "azure_vnet_id" {
  value = "${azurerm_virtual_network.VirtualNetwork.id}"
}

output "azure_vnet_name" {
  value = "${azurerm_virtual_network.VirtualNetwork.name}"
}

output "azure_vnet_cidr" {
  value = "${azurerm_virtual_network.VirtualNetwork.address_space}"
}

output "en_subnet_id" {
  value = "${azurerm_subnet.en.id}"
}

output "en_subnet_cidr" {
  value = "${azurerm_subnet.en.address_prefix}"
}

output "scn_subnet_id" {
  value = "${azurerm_subnet.scn.id}"
}

output "scn_subnet_cidr" {
  value = "${azurerm_subnet.scn.address_prefix}"
}