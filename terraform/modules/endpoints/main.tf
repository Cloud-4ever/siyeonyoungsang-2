# VPC 안의 private 리소스들이 인터넷을 안나가고도 AWS 서비스에 붙게 해주는 모듈 
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  route_table_ids   = var.route_table_ids
  vpc_endpoint_type = "Gateway"

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-s3-endpoint"
  })
}

resource "aws_vpc_endpoint" "secrets_manager" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.secretsmanager"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [var.endpoint_security_group_id]
  private_dns_enabled = true
  vpc_endpoint_type   = "Interface"

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-secrets-endpoint"
  })
}
