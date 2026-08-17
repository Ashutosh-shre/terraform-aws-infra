resource "aws_security_group" "main" {
  name        = "${local.project}-security-group"
  description = "Main security group for the project"
  vpc_id      = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${local.project}-security-group"
  })

}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.main.id
  ip_protocol       = var.ingress_rules["allow_http"].protocol
  to_port           = var.ingress_rules["allow_http"].to_port
  from_port         = var.ingress_rules["allow_http"].from_port
  cidr_ipv4         = var.ingress_rules["allow_http"].cidr_blocks
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.main.id
  ip_protocol       = var.ingress_rules["allow_ssh"].protocol
  to_port           = var.ingress_rules["allow_ssh"].to_port
  from_port         = var.ingress_rules["allow_ssh"].from_port
  cidr_ipv4         = var.ingress_rules["allow_ssh"].cidr_blocks
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.main.id
  ip_protocol       = var.egress_rules.ip_protocol
  cidr_ipv4         = var.egress_rules.cidr_blocks
}





