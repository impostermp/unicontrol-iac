
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.db_identifier
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.db_identifier}"
  }
}

resource "aws_db_instance" "rds_instance" {
  identifier              = var.db_identifier
  engine                  = var.db_engine
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_allocated_storage

  username = jsondecode(data.aws_secretsmanager_secret_version.db_secret_value.secret_string)["db_username"]
  password = jsondecode(data.aws_secretsmanager_secret_version.db_secret_value.secret_string)["db_password"]

  publicly_accessible     = var.publicly_accessible
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  availability_zone       = var.availability_zone
  multi_az                = var.multi_az
  skip_final_snapshot     = var.skip_final_snapshot

  tags = var.tags
}

# Secrets Manager to store DB credentials
resource "aws_secretsmanager_secret" "db_secret" {
  name        = var.secret_name
  description = "Credentials for the ${var.db_identifier} database"
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    db_username = var.db_username
    db_password = var.db_password
  })
}

data "aws_secretsmanager_secret_version" "db_secret_value" {
  secret_id = aws_secretsmanager_secret.db_secret.id
}