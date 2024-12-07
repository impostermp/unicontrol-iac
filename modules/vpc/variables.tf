variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "vpc_name" {
  description = "VPC"
  type        = string
}
variable "availability_zones_db" {
  type    = list(string)
  default = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}
variable "availability_zones" {
  type    = list(string)
  default = ["eu-central-1a", "eu-central-1b"]
}
variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.10.1.0/24", "10.10.2.0/24"]
}
variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.10.3.0/24", "10.10.4.0/24"]
}
