data "aws_ami" "node_ami" {
  most_recent = true
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_security_group" "common" {
  name        = var.security_group
  description = "Service chain default security group"
  vpc_id      = var.vpc_id
  tags        = var.tags
}

resource "aws_security_group_rule" "ingress_ssh_tcp" {
  security_group_id = aws_security_group.common.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.ssh_client_ips
}

resource "aws_security_group_rule" "ingress_network_tcp" {
  security_group_id        = aws_security_group.common.id
  type                     = "ingress"
  from_port                = 32323
  to_port                  = 32324
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.common.id
}

resource "aws_security_group_rule" "ingress_network_udp" {
  security_group_id        = aws_security_group.common.id
  type                     = "ingress"
  from_port                = 32323
  to_port                  = 32323
  protocol                 = "udp"
  source_security_group_id = aws_security_group.common.id
}

resource "aws_security_group_rule" "ingress_anchoring_network_tcp" {
  security_group_id        = aws_security_group.common.id
  type                     = "ingress"
  from_port                = 50505
  to_port                  = 50506
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.common.id
}

resource "aws_security_group_rule" "ingress_scn_eip_network_tcp" {
  count                    = var.scn_public_ip ? var.scn_instance_count : 0
  security_group_id        = aws_security_group.common.id
  type                     = "ingress"
  from_port                = 32323
  to_port                  = 32324
  protocol                 = "tcp"
  cidr_blocks              = ["${aws_eip.scn[count.index].public_ip}/32"]
}

resource "aws_security_group_rule" "ingress_scn_eip_network_udp" {
  count                    = var.scn_public_ip ? var.scn_instance_count : 0
  security_group_id        = aws_security_group.common.id
  type                     = "ingress"
  from_port                = 32323
  to_port                  = 32323
  protocol                 = "udp"
  cidr_blocks              = ["${aws_eip.scn[count.index].public_ip}/32"]
}

resource "aws_security_group_rule" "ingress_scn_anchoring_eip_tcp" {
  count                    = var.scn_public_ip ? var.scn_instance_count : 0
  security_group_id        = aws_security_group.common.id
  type                     = "ingress"
  from_port                = 50505
  to_port                  = 50506
  protocol                 = "tcp"
  cidr_blocks              = ["${aws_eip.scn[count.index].public_ip}/32"]
}

resource "aws_security_group_rule" "ingress_en_anchoring_eip_tcp" {
  count                    = var.en_instance_count
  security_group_id        = aws_security_group.common.id
  type                     = "ingress"
  from_port                = 50505
  to_port                  = 50506
  protocol                 = "tcp"
  cidr_blocks              = ["${aws_eip.en[count.index].public_ip}/32"]
}

resource "aws_security_group_rule" "ingress_en_eip_network_tcp" {
  count                    = var.en_instance_count
  security_group_id        = aws_security_group.common.id
  type                     = "ingress"
  from_port                = 32323
  to_port                  = 32324
  protocol                 = "tcp"
  cidr_blocks              = ["${aws_eip.en[count.index].public_ip}/32"]
}

resource "aws_security_group_rule" "ingress_en_eip_network_udp" {
  count                    = var.en_instance_count
  security_group_id        = aws_security_group.common.id
  type                     = "ingress"
  from_port                = 32323
  to_port                  = 32323
  protocol                 = "udp"
  cidr_blocks              = ["${aws_eip.en[count.index].public_ip}/32"]
}

resource "aws_security_group_rule" "ingress_network_rpc" {
  security_group_id        = aws_security_group.common.id
  type                     = "ingress"
  from_port                = 8551
  to_port                  = 8551
  protocol                 = "tcp"
  cidr_blocks              = var.ssh_client_ips
}

resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.common.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}


resource "aws_key_pair" "common" {
  key_name   = var.aws_key_pair_name
  public_key = var.ssh_pub_key
}
