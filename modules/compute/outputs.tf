output "node_group_arns" {
  value = { for ng in aws_eks_node_group.shared_cluster_nodes : ng.id => ng.resources[*].autoscaling_group_arn }
}
