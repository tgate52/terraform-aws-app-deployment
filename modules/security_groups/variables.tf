##############################################
# VARIABLES FOR SECURITY GROUP MODULE
##############################################

variable "project_name" {
  description = "Prefix used for naming security groups"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID used to attach security groups"
  type        = string
}
