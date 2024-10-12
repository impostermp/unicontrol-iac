provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "alpha/terraform.tfstate"
    region = "us-east-1"
  }
}
