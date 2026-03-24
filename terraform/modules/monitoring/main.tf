# 운영 / 감시 리소스 

# Cloudwatch 정의
# security에서 생성된 키 사용 
resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/${var.name_prefix}/application"
  retention_in_days = 30
  kms_key_id        = var.log_kms_key_arn

  tags = var.tags
}

# GuardDuty -> 위협 탐지 서비스 
# 계정/리전에 대해 GuardDuty 활성화 
# 네트워크, DNS, CloudTrail, VPC Flow Logs 같은 이벤트 바탕 이상 징후 탐지 
resource "aws_guardduty_detector" "this" {
  enable = true

  tags = var.tags
}

# AWS config 
# 리소스 변경 이럭 기록 
resource "aws_config_configuration_recorder" "this" {
  name     = "${var.name_prefix}-config-recorder"
  role_arn = aws_iam_role.config.arn
}

resource "aws_iam_role" "config" {
  name = "${var.name_prefix}-config-role-77025a"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "config.amazonaws.com"
      }
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "config" {
  role       = aws_iam_role.config.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}
