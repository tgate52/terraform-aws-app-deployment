###############################################################
# VARIABLES FOR EC2 MODULE
###############################################################

variable "project_name" {
  type        = string
  description = "Prefix for naming resources"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "private_subnet_id" {
  type        = string
  description = "Private subnet where EC2 will live"
}

variable "ec2_sg_id" {
  type        = string
  description = "Security group for the EC2 instance"
}

variable "ecr_url" {
  type        = string
  description = "ECR repository URL for pulling the app image"
}

variable "container_name" {
  type        = string
  description = "Name of the container to run"
}
