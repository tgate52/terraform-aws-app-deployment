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
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"

  lifecycle_policy {
    policy = jsonencode({
      rules = [{
        rulePriority = 1
        description  = "Retain only the 10 most recent images"
        selection = {
          tagStatus = "any"
          countType = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }]
    })
  }

  tags = {
    Name = var.repository_name
  }
}
