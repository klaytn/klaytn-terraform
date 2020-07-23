output "en_public_ip" {
  value = "${azurerm_public_ip.en-pip.*.ip_address}"
}

output "en_private_ip" {
  description = "private ip addresses of the vm nics"
  value       = "${azurerm_network_interface.en.*.private_ip_address}"
}

output "scn_private_ip" {
  description = "private ip addresses of the vm nics"
  value       = "${azurerm_network_interface.scn.*.private_ip_address}"
}