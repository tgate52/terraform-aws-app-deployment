###############################################################
# EC2 MODULE OUTPUTS
###############################################################

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "EC2 private IP"
  value       = aws_instance.this.private_ip
}

output "instance_profile" {
  description = "IAM instance profile"
  value       = aws_iam_instance_profile.this.name
}
