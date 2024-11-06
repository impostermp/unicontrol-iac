variable "vpc_cidr" {
  type    = string
  default = "192.169.0.0/16" 
}

variable "availability_zones" {
  type    = list(string)
  default = ["eu-central-1a", "eu-central-1b"]
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["192.169.0.0/18", "192.169.64.0/18"]  
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["192.169.128.0/18", "192.169.192.0/18"]  
}
