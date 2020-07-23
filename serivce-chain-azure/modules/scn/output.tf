output "scn_vm_id" {
  value = "${azurerm_virtual_machine.scn.*.id}"
}

output "scn_private_ip_address" {
  value = "${azurerm_network_interface.scn.*.private_ip_address}"
}