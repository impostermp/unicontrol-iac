output "subnet_ids" {
  value = {
    public  = module.gke_vpc.public_subnet_cidrs
    private = module.gke_vpc.private_subnet_cidrs
  }
  description = "Combined public and private subnet IDs"
}
output "eks_cluster_role_arn" {
  value = module.iam.eks_cluster_role_arn
  description = "ARN of the IAM role for the EKS cluster"
}

output "vpc_id" {
  description = "The ID of the GKE VPC"
  value       = module.gke_vpc.vpc_id
}