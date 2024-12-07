provider "aws" {
  region = var.region
}

data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket         = "prod-state-tf"
    key            = "prod/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock-table-prod"
  }
}

module "eks_node_groups" {
  source        = "../../modules/eks_node_groups"
  cluster_name  = data.terraform_remote_state.shared.outputs.eks_cluster_name
  subnet_ids    = data.terraform_remote_state.shared.outputs.private_subnet_ids
  environment   = var.environment

  node_role_arn = data.terraform_remote_state.shared.outputs.eks_cluster_role_arn

  node_groups = {
    "unicontrol-${var.environment}-0" = {
      instance_type = "t3.medium"
      desired_size  = 2
      max_size      = 2
      min_size      = 2
    }
  }
}