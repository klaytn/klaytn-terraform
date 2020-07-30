output "en_vm_id" {
  value = "${azurerm_virtual_machine.en.*.id}"
}

output "en_public_ip_id" {
  value = "${azurerm_public_ip.en-Pip.*.id}"
}

output "en_public_ip_address" {
  value = "${azurerm_public_ip.en-Pip.*.ip_address}"
}

output "en_private_ip_address" {
  value = "${azurerm_network_interface.en.*.private_ip_address}"
}