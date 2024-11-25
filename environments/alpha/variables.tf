variable "availability_zones" {
  type    = list(string)
  default = ["eu-central-1a", "eu-central-1b"]
}

variable "environment" {
  type    = string
  default = "alpha"
}
variable "region" {
  type = string
  default = "eu-central-1"
}