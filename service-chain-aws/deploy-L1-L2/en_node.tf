resource "aws_instance" "en" {
  count                       = var.en_instance_count
  ami                         = data.aws_ami.node_ami.id
  instance_type               = var.en_instance_type
  vpc_security_group_ids      = [aws_security_group.l1_common_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.common.key_name
  subnet_id                   = var.en_subnet_ids[count.index % length(var.en_subnet_ids)]

  root_block_device {
    volume_type = "gp2"
    volume_size = var.en_ebs_volume_size
  }

  tags = merge(var.tags, {
    Name = "${var.name}-en-${count.index + 1}"
  })

  lifecycle {
    # Don't replace the node when the AMI is updated -- it can simply be upgraded separately
    ignore_changes = [ami]
  }
}

resource "aws_eip" "en" {
  count = var.en_instance_count
  vpc   = true
  tags = merge(var.tags, {
    Name = "${var.name}-en-${count.index + 1}"
  })

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_eip_association" "en" {
  count         = var.en_instance_count
  instance_id   = aws_instance.en[count.index].id
  allocation_id = aws_eip.en[count.index].id
}
