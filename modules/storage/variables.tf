variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "db_name" {
  description = "The name of the RDS database"
  type        = string
}

variable "db_username" {
  description = "The username for the RDS database"
  type        = string
}

variable "db_password" {
  description = "The password for the RDS database"
  type        = string
  sensitive   = true
}

variable "db_allocated_storage" {
  description = "The allocated storage size for the RDS database (in GB)"
  type        = number
  default     = 20
}

variable "db_instance_class" {
  description = "The instance class for the RDS database"
  type        = string
  default     = "db.t3.micro"
}
