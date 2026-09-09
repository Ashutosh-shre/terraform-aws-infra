locals {
  project = "ashu-terraform"
  common_tags = {
    project    = local.project
    managed_by = "terraform"
    owner      = "ashu"
  }
  ami_id = {
    ubuntu = data.aws_ami.ubuntu.id
    linux  = data.aws_ami.linux.id

  }
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)

  public_subnet_indexes = [
    for index, config in var.subnet_config : index
    if config.type == "public"
  ]

  private_subnet_indexes = [
    for index, config in var.subnet_config : index
    if config.type == "private"
  ]


  instance_config = concat(
    [

      for index in range(var.public_instance_count) :
      {
        subnet_index = local.public_subnet_indexes[index % length(local.public_subnet_indexes)]
        ami_id       = local.ami_id.linux
        public_ip    = true
        type         = "public"
      }
    ],
    [
      for index in range(var.private_instance_count) :
      {
        subnet_index = local.private_subnet_indexes[index % length(local.private_subnet_indexes)]
        ami_id       = local.ami_id.ubuntu
        public_ip    = false
        type         = "private"
      }
    ]
  )
}
