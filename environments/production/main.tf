module "networking" {
  source = "../../modules/networking"
  vpc_cidr = var.vpc_cidr
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
}

module "compute" {
  source = "../../modules/compute"
  instance_type = var.instance_type
}
