terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "availability-testings-bucket"
    key    = "terraform.tfstate"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

module "network" {
  source = "./modules/network"

  project_name             = var.project_name
  environment              = var.environment
  vpc_cidr                 = var.vpc_cidr
  availability_zones_count = 3
  tags                     = local.common_tags
}

module "alb" {
  source = "./modules/alb"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  target_port       = var.app_port
  tags              = local.common_tags
}

module "ecs" {
  source = "./modules/ecs"

  project_name          = var.project_name
  environment           = var.environment
  aws_region            = var.aws_region
  vpc_id                = module.network.vpc_id
  private_subnet_ids    = module.network.private_subnet_ids
  alb_security_group_id = module.alb.alb_security_group_id
  target_group_arn      = module.alb.target_group_arn
  alb_listener_arn      = module.alb.listener_arn
  container_port        = var.app_port
  desired_count         = 3
  tags                  = local.common_tags
}

module "fis" {
  source = "./modules/fis"

  project_name              = var.project_name
  environment               = var.environment
  ecs_cluster_name          = module.ecs.ecs_cluster_name
  ecs_cluster_arn           = module.ecs.ecs_cluster_arn
  ecs_service_name          = module.ecs.ecs_service_name
  target_availability_zones = var.fis_target_availability_zones
  tags                      = local.common_tags
}
