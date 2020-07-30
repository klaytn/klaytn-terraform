output "en_public_ip" {
  value = "${module.en_vm.*.en_public_ip_address}"
}

output "en_private_ip" {
  description = "private ip addresses of the vm nics"
  value       = "${module.en_vm.*.en_private_ip_address}"
}

output "scn_private_ip" {
  description = "private ip addresses of the vm nics"
  value       = "${module.scn_vm.*.scn_private_ip_address}"
}