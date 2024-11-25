provider "aws" {
  region = var.region
}

module "shared_vpc" {
  source         = "../../modules/shared-vpc"
  vpc_cidr = "10.0.0.0/16"
}

module "eks" {
  source       = "../../modules/compute/eks"
  cluster_name = "shared-eks-cluster"
  subnet_ids = concat(module.shared_vpc.private_subnet_ids, module.shared_vpc.public_subnet_ids)

  node_groups = {
    beta-1 = {
      instance_type = "t3.medium"
      desired_size  = 4
      max_size      = 5
      min_size      = 3
    }
  }
}
