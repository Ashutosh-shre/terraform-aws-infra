resource "aws_key_pair" "main" {
  key_name   = "ashu-keypair"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/rbttHGXlLd9gpo5PPfoAsRbRg8/NDyFHO2YV+jqDt Ashutosh Kumar@LAPTOP-I3LN44BG"
  tags = {
    Name       = "ashu-keypair"
    project    = "ashu-terraform"
    managed_by = "terraform"
    owner      = "ashu"
  }
}