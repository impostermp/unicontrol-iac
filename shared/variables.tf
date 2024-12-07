variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
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
variable "db_username" {
  type = string
}
variable "db_password" {
  type = string
}
variable "vpc_name" {
  type = string
}
