output "scn_ip_addr" {
  description = "SCN instance nodes' private ip. It might help create inventory file when it comes to use ansible"
  value       = ["${aws_instance.scn.*.private_ip}"]
}
output "en_ip_addr" {
  description = "EN instance nodes' private ip. It might help create inventory file when it comes to use ansible"
  value       = ["${aws_instance.en.*.private_ip}"]
}
