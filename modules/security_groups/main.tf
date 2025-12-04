##############################################
# SECURITY GROUPS MODULE
# ----------------------
# This module creates:
#
# 1. ALB Security Group
#    - Inbound: HTTP (80) from anywhere
#    - Outbound: allowed (so ALB can reach EC2)
#
# 2. EC2 Security Group
#    - Inbound: ONLY from ALB SG (secure practice)
#    - Outbound: allowed (EC2 needs outbound to pull
#                Docker images from ECR via NAT gateway)
#
# These rules reflect real-world, least-privilege access.
##############################################

# --------------------------
# ALB Security Group
# --------------------------
resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  # Allow inbound HTTP from anywhere
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

# --------------------------
# EC2 Security Group
# --------------------------
resource "aws_security_group" "ec2_sg" {
  name        = "${var.project_name}-ec2-sg"
  description = "Security group for EC2 instance"
  vpc_id      = var.vpc_id

  # Allow inbound traffic ONLY from ALB
  ingress {
    description = "Allow traffic from ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"

    # Tightest security: Only allow traffic from ALB SG
    security_groups = [
      aws_security_group.alb_sg.id
    ]
  }

  # Allow all outbound (needed for ECR pull via NAT)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ec2-sg"
  }
}
