module "iam" {
  source = "../../modules/iam"
}

resource "aws_eks_cluster" "shared_cluster" {
  name     = "unicontrol-cloud-cluster2"
  role_arn = var.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  version = "1.29"
}
