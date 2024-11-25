provider "aws" {
  region = var.region
}

module "shared_vpc" {
  source         = "../../modules/shared-vpc"
  vpc_cidr = "10.0.0.0/16"
}

module "eks" {
  source            = "../../modules/compute/eks"
  cluster_name      = "shared-eks-cluster"
  subnet_ids        = module.shared_vpc.subnet_ids
  environment       = var.environment  # Passing the environment variable

  node_groups = {
    "unicontrol-${var.environment}-0" = {
      instance_type = "t3.medium"
      desired_size  = 2
      max_size      = 2
      min_size      = 2
    }
  }
}
