###############################################################
# ECR MODULE
# ----------
# Creates:
# - ECR Repository for application container
#
# Used by:
# - GitHub Actions workflow (pushes image)
# - EC2 module (pulls image)
###############################################################

resource "aws_ecr_repository" "this" {
  name = var.repository_name

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.project_name}-ecr"
  }
}
