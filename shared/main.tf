module "rds" {
  source               = "../modules/database"
  db_identifier        = "clouddb"
  db_engine            = "mariadb"
  db_username          = var.db_username
  db_password          = var.db_password
  db_allocated_storage = 5
  db_instance_class    = "db.t3.micro"
  subnet_ids           = module.db_vpc.private_subnet_ids
  publicly_accessible  = false
  db_engine_version    = 10.5
  secret_name          = "db_secrets"
  #multi_az true by default
}

# gke vpc
module "gke_vpc" {
  source               = "../modules/vpc"
  vpc_cidr             = "10.0.0.0/16"
  vpc_name             = "unicontrol-cloud-eks-vpc-stack2-VPC"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones   = ["eu-central-1a", "eu-central-1b"]
}

# db VPC
module "db_vpc" {
  source               = "../modules/vpc"
  vpc_cidr             = "10.1.0.0/16"
  vpc_name             = "db-vpc"
  public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  private_subnet_cidrs = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
  availability_zones   = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

module "iam" {
  source = "../modules/iam"
}

module "eks_cluster" {
  source = "../modules/eks_cluster"

  cluster_name = "unicontrol-cloud-cluster2"
  subnet_ids   = module.gke_vpc.private_subnet_cidrs
  iam_role_arn = module.iam.eks_cluster_role_arn
}
