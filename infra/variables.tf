###############################################################
# ROOT VARIABLES
###############################################################

variable "region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  type        = string
  description = "Name prefix for all resources"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "azs" {
  type        = list(string)
  description = "Availability zones for subnets"
}

variable "ami_id" {
  type        = string
  description = "AMI used for EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "ecr_url" {
  type        = string
  description = "Full ECR repo URL for Docker image"
}

variable "container_name" {
  type        = string
  description = "Name of the Docker container"
}
