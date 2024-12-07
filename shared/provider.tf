provider "aws" {
  region  = "eu-central-1"
  profile = "default"
}

terraform {
  backend "s3" {
    bucket         = "shared-tf-state-bucket"
    key            = "shared/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
  }
}
