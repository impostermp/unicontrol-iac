variable "availability_zones" {
  type    = list(string)
  default = ["eu-central-1a", "eu-central-1b"]
}

variable "environment" {
  type    = string
  default = "beta"
}
variable "region" {
  type = string
  default = "eu-central-1"
}