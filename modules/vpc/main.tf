resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_eip" "nat" {
  count  = length(var.public_subnet_cidrs)
  domain = "vpc"
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = format("unicontrol-cloud-eks-vpc-stack2-PublicSubnet%02d", count.index + 1)
  }
}

resource "aws_subnet" "private_subnet" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false # Private subnet, no public IP

  tags = {
    Name = format("unicontrol-cloud-eks-vpc-stack2-PrivateSubnet%02d", count.index + 1)
  }
}

# NAT Gateway for each public subnet
resource "aws_nat_gateway" "example_nat" {
  count         = length(var.private_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.private_subnet[count.index].id

  tags = {
    Name = format("unicontrol-cloud-eks-vpc-stack2-NatGatewayAZ%02d", count.index + 1)
  }
}

# Route Table (one route table per NAT Gateway)
resource "aws_route_table" "example_route_table" {
  for_each = { for idx, subnet in var.private_subnet_cidrs : idx => subnet }
  vpc_id   = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example_nat[each.key].id
  }

  route {
    cidr_block = aws_vpc.vpc.cidr_block
    gateway_id = "local"
  }
  tags = {
    Name = format("Private Subnet AZ%s", each.key + 1)
  }
}

# Route Table Association for each private subnet
resource "aws_route_table_association" "subnet_association" {
  for_each = toset([for idx in range(length(var.private_subnet_cidrs)) : tostring(idx)])

  subnet_id      = aws_subnet.private_subnet[each.value].id
  route_table_id = aws_route_table.example_route_table[each.value].id
}