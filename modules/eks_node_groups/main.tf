resource "aws_eks_node_group" "shared_cluster_nodes" {
  for_each       = var.node_groups
  cluster_name   = var.cluster_name
  node_role_arn  = var.node_role_arn
  subnet_ids     = var.subnet_ids
  instance_types = [each.value.instance_type]

  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
    min_size     = each.value.min_size
  }

  node_group_name = each.key

  tags = {
    Name = each.key
  }
}
