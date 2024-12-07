output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "public_subnet_cidrs" {
  value = aws_subnet.public_subnet[*].cidr_block
  description = "CIDR blocks of the public subnets"
}

output "private_subnet_cidrs" {
  value = aws_subnet.private_subnet[*].cidr_block
  description = "CIDR blocks of the private subnets"
}
