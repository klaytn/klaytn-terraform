resource "aws_instance" "spn" {
  count                       = var.spn_instance_count
  ami                         = data.aws_ami.node_ami.id
  instance_type               = var.spn_instance_type
  vpc_security_group_ids      = [aws_security_group.l2_common_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.common.key_name
  subnet_id                   = var.spn_subnet_ids[count.index % length(var.spn_subnet_ids)]

  root_block_device {
    volume_type = "gp2"
  }

  tags = merge(var.tags, {
    Name = "${var.name}-spn-${count.index + 1}"
  })

  lifecycle {
    # Don't replace the node when the AMI is updated -- it can simply be upgraded separately
    ignore_changes = [ami]
  }
}

resource "aws_ebs_volume" "spn_data" {
  count             = var.spn_instance_count
  availability_zone = aws_instance.spn[count.index].availability_zone
  size              = var.spn_ebs_volume_size
  type              = "gp2"

  tags = merge(var.tags, {
    Name = "${var.name}-spn-${count.index + 1}"
  })
}

resource "aws_volume_attachment" "spn_data" {
  count       = var.spn_instance_count
  volume_id   = aws_ebs_volume.spn_data[count.index].id
  instance_id = aws_instance.spn[count.index].id
  device_name = "/dev/sdb"
}

resource "aws_eip" "spn" {
  count = var.spn_instance_count
  vpc   = true
  tags = merge(var.tags, {
    Name = "${var.name}-spn-${count.index + 1}"
  })

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_eip_association" "spn" {
  count         = var.spn_instance_count
  instance_id   = aws_instance.spn[count.index].id
  allocation_id = aws_eip.spn[count.index].id
}