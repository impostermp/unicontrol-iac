module "test3" {
  source       = "../../../modules/compute/eks"
  cluster_name = "shared-eks-cluster"
  subnet_ids   = "10.10.1.0/24"
  environment  = "dev"

  node_groups = {
    "unicontrol-test-0" = {
      instance_type = "t3.medium"
      desired_size  = 11
      max_size      = 2
      min_size      = 2
    }
  }
}
