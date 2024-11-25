resource "aws_s3_bucket" "app_bucket" {
  bucket = var.bucket_name

  tags = {
    Name = "app_bucket"
  }
}

resource "aws_db_instance" "db_instance" {
  allocated_storage    = var.db_allocated_storage
  engine               = "postgres"
  engine_version       = "12.4"
  instance_class       = var.db_instance_class
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.postgres12"

  tags = {
    Name = "app_database"
  }
}
