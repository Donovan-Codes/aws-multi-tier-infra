# Donovan-Codes : Configuring Terraform Version Constraints and Required Providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"
}

# Donovan-Codes : Initializing AWS Provider with Default Tags Applied to All Resources
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

# Donovan-Codes : Invoking VPC Module to Build Network Foundation
module "vpc" {
  source = "./modules/vpc"

  project_name             = var.project_name
  vpc_cidr                 = var.vpc_cidr
  availability_zones       = var.availability_zones
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs
}

# Donovan-Codes : Invoking ALB Module to Deploy Internet-Facing Load Balancer
module "alb" {
  source = "./modules/alb"

  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

# Donovan-Codes : Invoking EC2 Module to Deploy Auto Scaling Group in Private Subnets
module "ec2" {
  source = "./modules/ec2"

  project_name           = var.project_name
  vpc_id                 = module.vpc.vpc_id
  private_app_subnet_ids = module.vpc.private_app_subnet_ids
  alb_security_group_id  = module.alb.alb_security_group_id
  target_group_arn       = module.alb.target_group_arn
  instance_type          = var.instance_type
  asg_min                = var.asg_min
  asg_max                = var.asg_max
  asg_desired            = var.asg_desired
}

# Donovan-Codes : Invoking RDS Module to Deploy MySQL Database in Isolated DB Subnets
module "rds" {
  source = "./modules/rds"

  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id
  private_db_subnet_ids = module.vpc.private_db_subnet_ids
  ec2_security_group_id = module.ec2.ec2_security_group_id
  db_instance_class     = var.db_instance_class
  db_name               = var.db_name
  db_username           = var.db_username
  db_password           = var.db_password
}
