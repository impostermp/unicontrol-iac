module "iam" {
  source = "../modules/iam"
}

resource "aws_eks_cluster" "shared_cluster" {
  name     = "unicontrol-cloud-cluster2"
  role_arn = module.iam.eks_cluster_role_arn

  vpc_config {
    subnet_ids = concat(module.shared_vpc.private_subnet_ids, module.shared_vpc.public_subnet_ids)
  }

  version = "1.29"
}

resource "aws_eks_node_group" "shared_cluster_nodes" {
  for_each       = var.node_groups
  cluster_name   = aws_eks_cluster.shared_cluster.name
  node_role_arn  = aws_iam_role.eks_node_role.arn
  subnet_ids     = concat(module.shared_vpc.private_subnet_ids, module.shared_vpc.public_subnet_ids)
  instance_types = [each.value.instance_type]

  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
    min_size     = each.value.min_size
  }

  # Dynamic naming based on the environment and node group name
  node_group_name = "unicontrol-${var.environment}-${each.key}"

  tags = {
    Name = "unicontrol-${var.environment}-${each.key}"
  }
}
