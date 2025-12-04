###########################################################
# ALB MODULE
# ----------
# This module creates:
# 1. Application Load Balancer (ALB)
# 2. Target Group (receives traffic from ALB)
# 3. Listener (port 80)
# 4. EC2 Instance attachment to the target group
#
# Purpose:
# The ALB sits in the PUBLIC SUBNETS and exposes the app
# to the internet. The EC2 instances live in PRIVATE SUBNETS
# and receive traffic ONLY from the ALB.
###########################################################

# --------------------------
# Application Load Balancer
# --------------------------
resource "aws_lb" "this" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"

  # ALB must be in PUBLIC subnets
  subnets         = var.public_subnet_ids
  security_groups = [var.alb_sg_id]

  enable_deletion_protection = false  # for demo / learning

  tags = {
    Name = "${var.project_name}-alb"
  }
}

# --------------------------
# Target Group
# --------------------------
resource "aws_lb_target_group" "this" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  # Health check ensures EC2 stays in rotation
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200"
  }

  tags = {
    Name = "${var.project_name}-tg"
  }
}

# --------------------------
# Listener for ALB (port 80)
# --------------------------
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

# --------------------------
# Register EC2 with Target Group
# --------------------------
resource "aws_lb_target_group_attachment" "ec2_attach" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = var.target_ec2_id
  port             = 80
}
