

resource "aws_instance" "main" {
  count                       = length(local.instance_config)
  ami                         = local.instance_config[count.index].ami_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.main.key_name
  vpc_security_group_ids      = [aws_security_group.main.id]
  subnet_id                   = aws_subnet.main[local.instance_config[count.index].subnet_index].id
  associate_public_ip_address = local.instance_config[count.index].public_ip
  root_block_device {
    volume_size           = var.root_block_device.volume_size
    volume_type           = var.root_block_device.volume_type
    delete_on_termination = var.root_block_device.delete_on_termination
  }
  tags = merge(local.common_tags, {
    Name = "${local.project}-${local.instance_config[count.index].type}-${length([
      for i in range(count.index + 1) :
      i if local.instance_config[i].type == local.instance_config[count.index].type
    ])}"
  })
}