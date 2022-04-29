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

resource "aws_instance" "scn" {
  count                       = var.scn_instance_count
  ami                         = data.aws_ami.node_ami.id
  instance_type               = var.scn_instance_type
  vpc_security_group_ids      = [aws_security_group.common.id]
  associate_public_ip_address = var.scn_public_ip
  key_name                    = aws_key_pair.common.key_name
  subnet_id                   = var.scn_subnet_ids[count.index % length(var.scn_subnet_ids)]

  root_block_device {
    volume_type = "gp2"
  }

  tags = merge(var.tags, {
    Name = "${var.name}-scn-${count.index + 1}"
  })

  lifecycle {
    # Don't replace the node when the AMI is updated -- it can simply be upgraded separately
    ignore_changes = [ami]
  }
}

resource "aws_ebs_volume" "scn_data" {
  count             = var.scn_instance_count
  availability_zone = aws_instance.scn[count.index].availability_zone
  size              = var.scn_ebs_volume_size
  type              = "gp2"

  tags = merge(var.tags, {
    Name = "${var.name}-scn-${count.index + 1}"
  })
}

resource "aws_volume_attachment" "scn_data" {
  count       = var.scn_instance_count
  volume_id   = aws_ebs_volume.scn_data[count.index].id
  instance_id = aws_instance.scn[count.index].id
  device_name = "/dev/sdb"
}

resource "aws_eip" "scn" {
  count = var.scn_public_ip ? var.scn_instance_count : 0
  vpc   = true
  tags = merge(var.tags, {
    Name = "${var.name}-scn-${count.index + 1}"
  })

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_eip_association" "scn" {
  count         = var.scn_public_ip ? var.scn_instance_count : 0
  instance_id   = aws_instance.scn[count.index].id
  allocation_id = aws_eip.scn[count.index].id
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

resource "aws_security_group_rule" "ingress_grafana_tcp" {
  security_group_id        = aws_security_group.common.id
  type                     = "ingress"
  from_port                = 61001
  to_port                  = 61001
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

resource "aws_security_group_rule" "ingress_grafana_public_tcp" {
  count                    = var.grafana_instance_count
  security_group_id        = aws_security_group.common.id
  type                     = "ingress"
  from_port                = 61001
  to_port                  = 61001
  protocol                 = "tcp"
  cidr_blocks              = ["${aws_eip.grafana[count.index].public_ip}/32"]
}

resource "aws_security_group_rule" "ingress_network_rpc" {
  security_group_id = aws_security_group.common.id
  type              = "ingress"
  from_port         = 8551
  to_port           = 8551
  protocol          = "tcp"
  cidr_blocks       = var.ssh_client_ips
}

resource "aws_security_group_rule" "ingress_grafana_dashboard" {
  security_group_id = aws_security_group.common.id
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = var.ssh_client_ips
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
