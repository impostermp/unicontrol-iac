provider "aws" {
  region  = "eu-central-1"
  profile = "default"
}

terraform {
  backend "s3" {
    bucket         = "tf-state-bucket"
    key            = "prod/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}
