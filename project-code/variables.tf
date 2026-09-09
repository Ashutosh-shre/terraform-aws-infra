# Provider variables
variable "region" {
  description = "Region where we deployed code"
  type        = string

}

# Network variables
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "subnet_config" {
  description = "total subnet created by terraform"
  type = list(object({
    cidr_block = string
    name       = string
    type       = string
  }))



}

variable "route_cidr" {
  description = "Route table cidr block for public and private"
  type        = string


}




# Security group variables


variable "ingress_rules" {
  description = "Ingress rules for the security group"
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = string
  }))
}
variable "egress_rules" {
  description = "Egress rules for the security group"
  type = object({
    cidr_blocks = string
    ip_protocol = string
  })

}
# Key pair variables
variable "key_pair_name" {
  description = "Name of the key pair"
  type        = string

}
variable "public_key" {
  description = "Public key for the key pair"
  type        = string
}

#compute variables

variable "public_instance_count" {
  description = "Number of instances to be in public subnet"
  type        = number

  validation {
    condition     = var.public_instance_count >= 0
    error_message = "Number of public instances must be greater than or equal to 1."
  }

}

variable "private_instance_count" {
  description = "Number of instances to be in private subnet"
  type        = number

  validation {
    condition     = var.private_instance_count >= 0
    error_message = "Number of private instances must be greater than or equal to 1."
  }
}
variable "instance_type" {
  description = "Instance type of ec2"
  type        = string
  validation {
    condition     = contains(["t2.micro", "t3.micro"], var.instance_type)
    error_message = "Invalid instance type. Allowed values are: t2.micro, t3.micro."
  }

}
variable "root_block_device" {
  description = "Root block device configuration"
  type = object({
    volume_size           = number
    volume_type           = string
    delete_on_termination = bool
  })
  validation {
    condition     = var.root_block_device.volume_size >= 8 && var.root_block_device.volume_size <= 20
    error_message = "Volume size is not in specified range"
  }
  validation {
    condition     = contains(["gp2", "gp3"], var.root_block_device.volume_type)
    error_message = "Invalid volume type. Allowed values are: gp2, gp3."
  }
}