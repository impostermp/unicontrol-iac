provider "aws" {
  region = var.region
}

data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket         = "beta-state-tf"
    key            = "beta/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock-table-beta"
  }
}

module "eks" {
  source       = "../../modules/compute/eks"
  cluster_name = "shared-eks-cluster"
  subnet_ids = data.terraform_remote_state.shared.outputs.subnet_ids

  node_groups = {
    beta-1 = {
      instance_type = "t3.medium"
      desired_size  = 4
      max_size      = 5
      min_size      = 3
    }
  }
}
