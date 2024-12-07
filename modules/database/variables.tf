variable "db_identifier" {
  description = "The identifier for the RDS instance"
  type        = string
}

variable "db_engine" {
  description = "The database engine to use (e.g., mariadb, postgres)"
  type        = string
}

variable "db_engine_version" {
  description = "The version of the database engine"
  type        = string
}

variable "db_instance_class" {
  description = "The instance type for the RDS instance"
  type        = string
}

variable "db_allocated_storage" {
  description = "The amount of storage (in GB) to allocate for the DB instance"
  type        = number
}

variable "db_username" {
  description = "The username for the database"
  type        = string
}

variable "db_password" {
  description = "The password for the database"
  type        = string
}

variable "secret_name" {
  description = "The name of the secret in AWS Secrets Manager"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "publicly_accessible" {
  description = "Whether the DB instance is publicly accessible"
  type        = bool
  default     = false
}

variable "availability_zone" {
  description = "The availability zone for the DB instance"
  type        = string
  default     = null
}

variable "multi_az" {
  description = "Whether the DB instance should be deployed across multiple AZs"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot when the DB instance is deleted"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
