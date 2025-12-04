###############################################################
# EC2 MODULE
# ----------
# This module creates:
# - IAM Role & Policy for ECR Access
# - Instance Profile (EC2 uses IAM role through this)
# - EC2 Instance in PRIVATE Subnet
# - User Data Script that:
#     * Installs Docker
#     * Logs into ECR
#     * Pulls the application image
#     * Runs the container
#
# This simulates real-world immutable infrastructure.
###############################################################

# --------------------------
# IAM Role for EC2 -> ECR Access
# --------------------------
resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-ec2-role"

  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
}

data "aws_iam_policy_document" "ec2_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# --------------------------
# IAM Policy for ECR Access
# --------------------------
resource "aws_iam_policy" "ecr_policy" {
  name        = "${var.project_name}-ecr-policy"
  description = "Allows EC2 to authenticate & pull images from ECR"

  policy = data.aws_iam_policy_document.ecr_access.json
}

data "aws_iam_policy_document" "ecr_access" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]

    resources = ["*"]
  }
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ecr_policy.arn
}

# --------------------------
# Instance Profile
# --------------------------
resource "aws_iam_instance_profile" "this" {
  name = "${var.project_name}-instance-profile"
  role = aws_iam_role.ec2_role.name
}

# --------------------------
# EC2 Instance (Private subnet)
# --------------------------
resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [var.ec2_sg_id]
  iam_instance_profile        = aws_iam_instance_profile.this.name
  associate_public_ip_address = true  

  user_data = base64encode(templatefile("${path.module}/user_data.sh.tpl", {
    ecr_url        = var.ecr_url
    container_name = var.container_name
  }))

  tags = {
    Name = "${var.project_name}-ec2"
  }
}
