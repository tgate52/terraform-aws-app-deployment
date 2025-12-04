###########################################################
# ALB MODULE VARIABLES
###########################################################

variable "project_name" {
  description = "Name prefix used for tagging resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs where ALB will live"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "target_ec2_id" {
  description = "EC2 instance ID to attach to the target group"
  type        = string
}
