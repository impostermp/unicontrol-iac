data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket         = "shared-tf-state-bucket"
    key            = "shared/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock-table"
  }
}

module "eks_node_groups_blue" {
  source       = "../../modules/eks_node_groups"
  cluster_name = data.terraform_remote_state.shared.outputs.eks_cluster_name
  subnet_ids   = data.terraform_remote_state.shared.outputs.subnet_ids.blue
  environment  = "${var.environment}-blue"

  node_groups = {
    "blue-unicontrol-${var.environment}" = {
      instance_type = "t3.medium"
      desired_size  = 2
      max_size      = 2
      min_size      = 2
    }
  }
}

module "eks_node_groups_green" {
  source       = "../../modules/eks_node_groups"
  cluster_name = data.terraform_remote_state.shared.outputs.eks_cluster_name
  subnet_ids   = data.terraform_remote_state.shared.outputs.subnet_ids.green
  environment  = "${var.environment}-green"

  node_groups = {
    "green-unicontrol-${var.environment}" = {
      instance_type = "t3.medium"
      desired_size  = 2
      max_size      = 2
      min_size      = 2
    }
  }
}

module "alpha_alb" {
  source          = "../../modules/alb"
  lb_name         = "alpha-alb"
  internal        = false
  security_groups = ["sg-xxxxxxxx"]
  subnet_ids      = module.alpha_vpc.public_subnet_ids

  target_group_name           = "alpha-blue-target-group"
  target_group_port           = 80
  target_group_protocol       = "HTTP"
  vpc_id                      = terraform_remote_state.shared.vpc_id
  green_target_group_name     = "alpha-green-target-group"
  green_target_group_port     = 80
  green_target_group_protocol = "HTTP"

  health_check_path     = "/health"
  health_check_interval = 30
  health_check_timeout  = 5
  healthy_threshold     = 3
  unhealthy_threshold   = 3
  listener_port         = 80
  listener_protocol     = "HTTP"

  tags = {
    Environment = "alpha"
    Name        = "alpha-alb"
  }
}
