provider "aws" {
  region = var.region
}

module "shared_vpc" {
  source     = "../../modules/shared-vpc"
  vpc_cidr = "10.0.0.0/16"
}

module "eks" {
  source       = "../../modules/compute/eks"
  cluster_name = "shared-eks-cluster"
  subnet_ids   = module.shared_vpc.subnet_ids

  node_groups = {
    prod-1 = {
      instance_type = "t3.large"
      desired_size  = 4
      max_size      = 6
      min_size      = 3
    }
  }
}
