aws_region                 = "ap-southeast-2"
project_name               = "security-app"
environment                = "dev"
vpc_cidr                   = "10.10.0.0/16"
availability_zones         = ["ap-southeast-2a", "ap-southeast-2c"]
public_subnet_cidrs        = ["10.10.0.0/24", "10.10.1.0/24"]
private_subnet_cidrs       = ["10.10.10.0/24", "10.10.11.0/24"]
isolated_subnet_cidrs      = ["10.10.20.0/24", "10.10.21.0/24"]
flow_log_retention_in_days = 1        # VPC 트래픽 로그 30일 보관 및 자동 삭제
flow_log_traffic_type      = "ALL"    # 허용 및 차단 트래픽 모두 기록  
instance_type              = "t3.micro"    # EC2 서버 사양
desired_capacity           = 2        # 평소 EC2 대수 
min_size                   = 2        # 최소 EC2 대수 
max_size                   = 4        # 최대 EC2 대수 
app_port                   = 8080     # EC2 listenk port  
db_name                    = "appdb"
db_username                = "appadmin"
db_password                = "test1234"
db_instance_class          = "db.t4g.micro"    # db 사양ㄴ
domain_name                = "example.com"

common_tags = {
  Project     = "security-app"    # 어느 프로젝트
  Environment = "dev"    # 어느 환경 
  ManagedBy   = "Terraform"    # 누가 생성
}
