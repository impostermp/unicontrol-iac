resource "aws_vpc" "shared_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "unicontrol-cloud-eks-vpc-stack2-VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.shared_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = format("unicontrol-cloud-eks-vpc-stack2-PublicSubnet%02d", count.index + 1)
  }
}


resource "aws_subnet" "private_subnet" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.shared_vpc.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = format("unicontrol-cloud-eks-vpc-stack2-PrivateSubnet%02d", count.index + 1)
  }
}
