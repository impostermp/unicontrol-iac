resource "aws_vpc" "shared_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "unicontrol-cloud-eks-vpc-stack2-VPC"
  }
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.shared_vpc.id

}

resource "aws_eip" "nat" {
  count  = length(var.public_subnet_cidrs)
  domain = "vpc"
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
  vpc_id   = aws_vpc.shared_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example_nat[each.key].id
  }

  route {
    cidr_block = aws_vpc.shared_vpc.cidr_block
    gateway_id = "local"
  }
  tags = {
    Name = format("Private Subnet AZ%s", each.key + 1)
  }
}

# Route Table Association for each private subnet
resource "aws_route_table_association" "subnet_association" {
  for_each = toset([for idx in range(length(var.private_subnet_cidrs)) : tostring(idx)]) # Convert `idx` to string

  subnet_id      = aws_subnet.private_subnet[each.value].id # Associate the correct subnet using each.value
  route_table_id = aws_route_table.example_route_table[each.value].id
}

resource "aws_vpc_db" "shared_vpc" {
  cidr_block = var.vpc_cidr_db

}

resource "aws_subnet" "db_subnets" {
  count = 3

  vpc_id     = aws_vpc_db.shared_vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr_db, 4, count.index)

  availability_zone = element(["eu-central-1a", "eu-central-1b", "eu-central-1c"], count.index)

}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "subnet-group"
  subnet_ids = aws_subnet.db_subnets[*].id

  tags = {
    Name = "subnet-group"
  }
}

# Create the secret in AWS Secrets Manager
resource "aws_secretsmanager_secret" "db_secret" {
  name        = "mariadb_credentials"
  description = "Credentials for the MariaDB instance"
}

# Store the secret value (username and password)
resource "aws_secretsmanager_secret_version" "db_secret_value" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    db_username = var.db_username
    db_password = var.db_password
  })
}

# Reference the secret in AWS Secrets Manager
data "aws_secretsmanager_secret_version" "db_secret_value" {
  secret_id = aws_secretsmanager_secret.db_secret.id
}

# Pass the secret to the RDS instance
resource "aws_db_instance" "mariadb" {
  identifier              = "cloudDB"
  engine                  = "mariadb"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20

  # Extract username and password from the secret
  username = jsondecode(data.aws_secretsmanager_secret_version.db_secret_value.secret_string)["db_username"]
  password = jsondecode(data.aws_secretsmanager_secret_version.db_secret_value.secret_string)["db_password"]

  publicly_accessible     = false
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  availability_zone       = null
  multi_az                = true
  skip_final_snapshot     = true

  tags = {
    Name = "cloudDB"
  }
}

output "db_password" {
  value       = jsondecode(data.aws_secretsmanager_secret_version.db_secret_value.secret_string)["password"]
}
