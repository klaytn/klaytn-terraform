output "scn_private_ip_addr" {
  description = "SCN instance nodes' private ip. It might help create inventory file when it comes to use ansible"
  value       = ["${aws_instance.scn.*.private_ip}"]
}
output "scn_public_ip_addr" {
  description = "SCN instance nodes' public ip. It might help create inventory file when it comes to use ansible"
  value       = ["${aws_eip.scn.*.public_ip}"]
}
output "en_private_ip_addr" {
  description = "EN instance nodes' private ip. It might help create inventory file when it comes to use ansible"
  value       = ["${aws_instance.en.*.private_ip}"]
}
output "en_public_ip_addr" {
  description = "EN instance nodes' public ip. It might help create inventory file when it comes to use ansible"
  value       = ["${aws_eip.en.*.public_ip}"]
}
output "grafana_public_ip_addr" {
  description = "Grafana instance nodes' public ip. It might help create inventory file when it comes to use ansible"
  value       = ["${aws_eip.grafana.*.public_ip}"]
}
