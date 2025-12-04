###############################################################
# ROOT MODULE — MAIN.TF
# ----------------------
# This file wires together all modules:
#
# 1. VPC
# 2. Security Groups
# 3. EC2
# 4. Application Load Balancer (ALB)
#
# This acts as the "blueprint" for the entire infrastructure.
###############################################################

#######################
# VPC MODULE
#######################
module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
}

#######################
# SECURITY GROUPS MODULE
#######################
module "security_groups" {
  source = "./modules/security_groups"

  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
}

#######################
# ECR MODULE
#######################
module "ecr" {
  source          = "./modules/ecr"
  repository_name = "${var.project_name}-repo"
}

#######################
# EC2 MODULE
#######################
module "ec2" {
  source = "./modules/ec2"

  project_name      = var.project_name
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  private_subnet_id = module.vpc.public_subnet_ids[0]
  ec2_sg_id         = module.security_groups.ec2_sg_id

  ecr_url = module.ecr.repository_url
  container_name = var.container_name
}

#######################
# ALB MODULE
#######################
module "alb" {
  source = "./modules/alb"

  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security_groups.alb_sg_id
  target_ec2_id     = module.ec2.instance_id
}
