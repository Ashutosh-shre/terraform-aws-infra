resource "aws_key_pair" "main" {
  key_name   = var.key_pair_name
  public_key = var.public_key
  tags = merge(local.common_tags, {
    Name = "${local.project}-keypair"
  })
}