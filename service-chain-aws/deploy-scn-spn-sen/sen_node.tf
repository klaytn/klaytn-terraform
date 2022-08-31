resource "aws_instance" "sen" {
  count                       = var.sen_instance_count
  ami                         = data.aws_ami.node_ami.id
  instance_type               = var.sen_instance_type
  vpc_security_group_ids      = [aws_security_group.common.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.common.key_name
  subnet_id                   = var.sen_subnet_ids[count.index % length(var.sen_subnet_ids)]

  root_block_device {
    volume_type = "gp2"
    volume_size = var.sen_ebs_volume_size
  }

  tags = merge(var.tags, {
    Name = "${var.name}-sen-${count.index + 1}"
  })

  lifecycle {
    # Don't replace the node when the AMI is updated -- it can simply be upgraded separately
    ignore_changes = [ami]
  }
}

resource "aws_eip" "sen" {
  count = var.sen_instance_count
  vpc   = true
  tags = merge(var.tags, {
    Name = "${var.name}-sen-${count.index + 1}"
  })

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_eip_association" "sen" {
  count         = var.sen_instance_count
  instance_id   = aws_instance.sen[count.index].id
  allocation_id = aws_eip.sen[count.index].id
}
