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
    volume_size = var.scn_ebs_volume_size
  }

  tags = merge(var.tags, {
    Name = "${var.name}-scn-${count.index + 1}"
  })

  lifecycle {
    # Don't replace the node when the AMI is updated -- it can simply be upgraded separately
    ignore_changes = [ami]
  }
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

