output "scn_private_ip_addr" {
  description = "SCN instance nodes' private ip. It might help create inventory file when it comes to use ansible"
  value       = ["${aws_instance.scn.*.private_ip}"]
}
output "scn_public_ip_addr" {
  description = "SCN instance nodes' private ip. It might help create inventory file when it comes to use ansible"
  value       = ["${aws_eip.scn.*.public_ip}"]
}

output "spn_public_ip_addr" {
  description = "SCN instance nodes' private ip. It might help create inventory file when it comes to use ansible"
  value       = ["${aws_eip.spn.*.public_ip}"]
}

output "sen_public_ip_addr" {
  description = "SCN instance nodes' private ip. It might help create inventory file when it comes to use ansible"
  value       = ["${aws_eip.sen.*.public_ip}"]
}

output "cn_private_ip_addr" {
  description = "CN instance nodes' private ip. It might help create inventory file when it comes to use ansible"
  value       = ["${aws_instance.cn.*.private_ip}"]
}
output "cn_public_ip_addr" {
  description = "CN instance nodes' private ip. It might help create inventory file when it comes to use ansible"
  value       = ["${aws_eip.cn.*.public_ip}"]
}

output "pn_private_ip_addr" {
  description = "PN instance nodes' private ip. It might help create inventory file when it comes to use ansible"
  value       = ["${aws_instance.pn.*.private_ip}"]
}
output "pn_public_ip_addr" {
  description = "PN instance nodes' private ip. It might help create inventory file when it comes to use ansible"
  value       = ["${aws_eip.pn.*.public_ip}"]
}

output "en_private_ip_addr" {
  description = "EN instance nodes' private ip. It might help create inventory file when it comes to use ansible"
  value       = ["${aws_instance.en.*.private_ip}"]
}
output "en_public_ip_addr" {
  description = "EN instance nodes' private ip. It might help create inventory file when it comes to use ansible"
  value       = ["${aws_eip.en.*.public_ip}"]
}
