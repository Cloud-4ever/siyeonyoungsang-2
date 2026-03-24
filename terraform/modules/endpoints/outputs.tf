output "s3_endpoint_id" {
  value = aws_vpc_endpoint.s3.id
}

output "secrets_manager_endpoint_id" {
  value = aws_vpc_endpoint.secrets_manager.id
}
