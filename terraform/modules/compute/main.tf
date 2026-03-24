# Get latest Amazon Linux 2023 AMI
data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
}

# ALB 정의
resource "aws_lb" "this" {
  name               = substr("${var.name_prefix}-alb", 0, 32)
  internal           = false         # pulbic 에서 접속 가능한 로드밸런서 
  load_balancer_type = "application" # 7계층 
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-alb"
  })
}

# Target Group 정의 ALB -> 최종으로 보낼 목적지(EC2)
resource "aws_lb_target_group" "this" {
  name        = substr("${var.name_prefix}-tg", 0, 32)
  port        = var.target_port
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  # 상태 검사 
  health_check {
    path = "/health"
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-tg"
  })
}

# ALB 수신 포트 
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

# Launch Template - 새로운 EC2가 생성될 떄 사용할 설계도 
resource "aws_launch_template" "this" {
  name_prefix   = "${var.name_prefix}-lt-"
  image_id      = data.aws_ssm_parameter.al2023_ami.value
  instance_type = var.instance_type

  # EC2가 Secret Manager에 접근할 권한(IAM Role) 부여
  iam_instance_profile {
    name = var.instance_profile_name
  }

  # Private 서브넷 생성 -> 공인 IP X 
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.application_sg_id]
  }

  # 서버가 처음 켜질 때 실행할 스크립트 
  # 민감 정보 위치를 환경 변수로 저장 
  user_data = base64encode(<<-EOT
    #!/bin/bash
    echo "SECRET_ARN=${var.secrets_manager_arn}" > /etc/app.env  
    echo "APP_PORT=${var.target_port}" >> /etc/app.env
  EOT
  )

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.tags, {
      Name = "${var.name_prefix}-app"
    })
  }
}

# Auto Scaling Group -> 서버 개수 조절 및 가용성 유지 
resource "aws_autoscaling_group" "this" {
  name                = "${var.name_prefix}-asg"
  desired_capacity    = var.desired_capacity   # 평소 띄울 대수 
  min_size            = var.min_size           # 최소 대수 
  max_size            = var.max_size           # 최대 대수(트래픽 몰릴 때 대비)
  vpc_zone_identifier = var.private_subnet_ids # Private 영역 존재 
  target_group_arns   = [aws_lb_target_group.this.arn]
  health_check_type   = "ELB"

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-app"
    propagate_at_launch = true
  }
}
