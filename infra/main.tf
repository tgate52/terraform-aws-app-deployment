########################################
# VPC MODULE
########################################

module "vpc" {
  source       = "../modules/vpc"
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
}

########################################
# SECURITY GROUPS MODULE
########################################

module "security_groups" {
  source       = "../modules/security_groups"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
}

########################################
# ECR MODULE
########################################

module "ecr" {
  source          = "../modules/ecr"
  project_name    = var.project_name
  repository_name = "${var.project_name}-repo"
}

########################################
# EC2 MODULE
########################################

module "ec2" {
  source                 = "../modules/ec2"
  project_name           = var.project_name

  # EC2 must live in a PUBLIC subnet for low-cost NAT-free deployment
  subnet_id              = module.vpc.public_subnet_ids[0]

  security_group_id      = module.security_groups.instance_sg_id
  instance_type          = var.instance_type

  # Pass ECR repo URL to EC2, to pull container image
  ecr_repo_url           = module.ecr.repository_url
}
