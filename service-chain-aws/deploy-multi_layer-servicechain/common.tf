data "aws_ami" "node_ami" {
  most_recent = true
  owners      = ["aws-marketplace"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }

  filter {
    name   = "name"
    values = ["CentOS Linux 7*"]
  }
}

resource "aws_security_group_rule" "ingress_en_l2_anchoring_sg_tcp" {
  security_group_id        = var.en_security_group_id
  type                     = "ingress"
  from_port                = 50505
  to_port                  = 50506
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.l2_common_sg.id
}

resource "aws_security_group_rule" "ingress_l1_scn_eip_network_tcp" {
  count                    = var.scn_instance_count
  security_group_id        = var.en_security_group_id
  type                     = "ingress"
  from_port                = 50505
  to_port                  = 50506
  protocol                 = "tcp"
  cidr_blocks              = ["${aws_eip.scn[count.index].public_ip}/32"]
}

resource "aws_security_group_rule" "ingress_l1_spn_eip_network_tcp" {
  count                    = var.spn_instance_count
  security_group_id        = var.en_security_group_id
  type                     = "ingress"
  from_port                = 50505
  to_port                  = 50506
  protocol                 = "tcp"
  cidr_blocks              = ["${aws_eip.spn[count.index].public_ip}/32"]
}

resource "aws_security_group_rule" "ingress_l1_sen_eip_network_tcp" {
  count                    = var.sen_instance_count
  security_group_id        = var.en_security_group_id
  type                     = "ingress"
  from_port                = 50505
  to_port                  = 50506
  protocol                 = "tcp"
  cidr_blocks              = ["${aws_eip.sen[count.index].public_ip}/32"]
}

resource "aws_security_group" "l2_common_sg" {
  name        = "${var.security_group}-layer2-sg"
  description = "ServiceChain Layer 2 security group"
  vpc_id      = var.vpc_id
  tags        = var.tags
}

resource "aws_security_group_rule" "ingress_l2_ssh_tcp" {
  security_group_id = aws_security_group.l2_common_sg.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.ssh_client_ips
}

resource "aws_security_group_rule" "ingress_l2_network_tcp" {
  security_group_id        = aws_security_group.l2_common_sg.id
  type                     = "ingress"
  from_port                = 32323
  to_port                  = 32324
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.l2_common_sg.id
}

resource "aws_security_group_rule" "ingress_l2_network_udp" {
  security_group_id        = aws_security_group.l2_common_sg.id
  type                     = "ingress"
  from_port                = 32323
  to_port                  = 32323
  protocol                 = "udp"
  source_security_group_id = aws_security_group.l2_common_sg.id
}

resource "aws_security_group_rule" "ingress_l2_scn_eip_network_tcp" {
  count                    = var.scn_public_ip ? var.scn_instance_count : 0
  security_group_id        = aws_security_group.l2_common_sg.id
  type                     = "ingress"
  from_port                = 32323
  to_port                  = 32324
  protocol                 = "tcp"
  cidr_blocks              = ["${aws_eip.scn[count.index].public_ip}/32"]
}

resource "aws_security_group_rule" "ingress_l2_scn_eip_network_udp" {
  count                    = var.scn_public_ip ? var.scn_instance_count : 0
  security_group_id        = aws_security_group.l2_common_sg.id
  type                     = "ingress"
  from_port                = 32323
  to_port                  = 32323
  protocol                 = "udp"
  cidr_blocks              = ["${aws_eip.scn[count.index].public_ip}/32"]
}

resource "aws_security_group_rule" "ingress_l2_en_eip_network_tcp" {
  security_group_id        = aws_security_group.l2_common_sg.id
  type                     = "ingress"
  from_port                = 32323
  to_port                  = 32324
  protocol                 = "tcp"
  source_security_group_id = var.en_security_group_id
}

resource "aws_security_group_rule" "ingress_l2_en_eip_network_udp" {
  security_group_id        = aws_security_group.l2_common_sg.id
  type                     = "ingress"
  from_port                = 32323
  to_port                  = 32323
  protocol                 = "udp"
  source_security_group_id = var.en_security_group_id
}

resource "aws_security_group_rule" "ingress_l2_network_rpc" {
  security_group_id        = aws_security_group.l2_common_sg.id
  type                     = "ingress"
  from_port                = 8551
  to_port                  = 8551
  protocol                 = "tcp"
  cidr_blocks              = var.ssh_client_ips
}

resource "aws_security_group_rule" "egress_l2" {
  security_group_id = aws_security_group.l2_common_sg.id
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
