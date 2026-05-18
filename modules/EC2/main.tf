resource "aws_instance" "app" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.aws_subnet_public_1
  vpc_security_group_ids = [var.security_group]

  # Installs Docker and runs the container on boot
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y docker
    systemctl start docker
    systemctl enable docker

    # Pull image from ECR
    aws ecr get-login-password --region ${var.region} | \
      docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com

    docker run -d \
      -p 8081:8081 \
      -e DB_HOST=${aws_db_instance.mysql.address} \
      -e DB_NAME=${var.db_name} \
      -e DB_USER=${var.db_user} \
      -e DB_PASS=${var.db_password} \
      --restart always \
      ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/two-tier-app:latest
  EOF

  iam_instance_profile = aws_iam_instance_profile.ec2_ecr.name
  tags = { Name = "two-tier-app" }
}

data "aws_caller_identity" "current" {}

# IAM role so EC2 can pull from ECR
resource "aws_iam_role" "ec2_ecr" {
  name = "ec2-ecr-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_read" {
  role       = aws_iam_role.ec2_ecr.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_ecr_repository" "two_tier_app" {
  name                 = "two-tier-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_iam_instance_profile" "ec2_ecr" {
  name = "ec2-ecr-profile"
  role = aws_iam_role.ec2_ecr.name
}

# ALB
resource "aws_lb" "app" {
  name               = "two-tier-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group]
  subnets            = [var.aws_subnet_public_1, var.aws_subnet_public_2]
  tags = { Name = "two-tier-alb" }
}

resource "aws_lb_target_group" "app" {
  name     = "two-tier-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/api/users/health"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 30
  }
}

resource "aws_lb_target_group_attachment" "app" {
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = aws_instance.app.id
  port             = 8080
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}