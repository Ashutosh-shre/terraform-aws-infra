locals {
  project = "ashu-terraform"
  common_tags = {
    project    = local.project
    managed_by = "terraform"
    owner      = "ashu"
  }
  ami_id = {
    ubuntu = data.aws_ami.ubuntu.id

  }
}