output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "The ID of the All public subnets"
  value = [
    for index in local.public_subnet_indexes : aws_subnet.main[index].id
  ]
}

output "private_subnet_ids" {
  description = "The ID of the private subnets"
  value = [
    for index in local.private_subnet_indexes : aws_subnet.main[index].id
  ]
}

output "public_instance_ids" {
  description = "The ID of the EC2 instance"
  value = [
    for index in range(var.public_instance_count) :
    aws_instance.main[local.public_subnet_indexes[index % length(local.public_subnet_indexes)]].id
  ]
}



output "elastic_ip" {
  description = "The Elastic IP address associated with the NAT Gateway"
  value = [
    for index in range(length(local.availability_zones)) : aws_eip.main[index].public_ip
  ]
}
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}
output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value = [
    for index in range(length(local.availability_zones)) : aws_nat_gateway.main[index].id
  ]

}
