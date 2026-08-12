resource "aws_security_group" "main" {
  name        = "ashu_security_group"
  description = "Main security group for the project"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name       = "ashu-security-group"
    project    = "ashu-terraform"
    managed_by = "terraform"
    owner      = "ashu"
  }

}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.main.id
  ip_protocol       = "tcp"
  to_port           = 80
  from_port         = 80
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.main.id
  ip_protocol       = "tcp"
  to_port           = 22
  from_port         = 22
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.main.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}





