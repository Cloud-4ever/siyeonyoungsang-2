output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "isolated_subnet_ids" {
  value = aws_subnet.isolated[*].id
}

output "private_route_table_ids" {
  value = aws_route_table.private[*].id
}

output "flow_log_id" {
  value = aws_flow_log.this.id
}

output "flow_log_log_group_name" {
  value = aws_cloudwatch_log_group.flow_logs.name
}
