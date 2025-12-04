###############################################################
# ROOT MODULE OUTPUTS
###############################################################

output "alb_dns" {
  description = "Public DNS name of ALB"
  value       = module.alb.alb_dns
}

output "ec2_private_ip" {
  description = "Private IP of EC2 instance"
  value       = module.ec2.private_ip
}

output "vpc_id" {
  description = "ID of VPC"
  value       = module.vpc.vpc_id
}
