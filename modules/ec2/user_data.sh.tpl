#!/bin/bash
# Install Docker
yum update -y
yum install -y docker
systemctl enable docker
systemctl start docker

# Login to ECR
aws ecr get-login-password --region $(curl -s http://169.254.169.254/latest/meta-data/placement/region) | \
docker login --username AWS --password-stdin ${ecr_url}

# Pull and run container
docker pull ${ecr_url}
docker run -d --name app -p 80:80 ${ecr_url}
