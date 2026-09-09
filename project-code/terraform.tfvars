region   = "us-east-1"
vpc_cidr = "10.0.0.0/16"
subnet_config = [
  {
    cidr_block = "10.0.1.0/24"
    name       = "public-subnet-1"
    type       = "public"
  },
  {
    cidr_block = "10.0.2.0/24"
    name       = "public-subnet-2"
    type       = "public"
  },
  {
    cidr_block = "10.0.3.0/24"
    name       = "private-subnet-1"
    type       = "private"
  },
  {
    cidr_block = "10.0.4.0/24"
    name       = "private-subnet-2"
    type       = "private"
  }
]

route_cidr = "0.0.0.0/0"



ingress_rules = {
  allow_http = {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
  }
  allow_ssh = {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
  }
}
egress_rules = {
  cidr_blocks = "0.0.0.0/0"
  ip_protocol = "-1"
}

key_pair_name          = "ashu-keypair"
public_key             = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/rbttHGXlLd9gpo5PPfoAsRbRg8/NDyFHO2YV+jqDt Ashutosh Kumar@LAPTOP-I3LN44BG"
public_instance_count  = 2
private_instance_count = 2
instance_type          = "t3.micro"
root_block_device = {
  volume_size           = 8
  volume_type           = "gp3"
  delete_on_termination = true
}
