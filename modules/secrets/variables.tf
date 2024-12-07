variable "secret_name" {
  description = "The name of the secret in AWS Secrets Manager"
  type        = string
}
variable "db_username" {
  description = "The username for the database"
  type        = string
}

variable "db_password" {
  description = "The password for the database"
  type        = string
}
variable "db_identifier" {
  description = "The identifier for the RDS instance"
  type        = string
}
