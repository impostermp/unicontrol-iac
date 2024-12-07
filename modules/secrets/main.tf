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
