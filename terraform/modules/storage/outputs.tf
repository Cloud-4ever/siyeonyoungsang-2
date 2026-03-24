output "static_bucket_name" {
  value = aws_s3_bucket.static.bucket
}

output "static_bucket_arn" {
  value = aws_s3_bucket.static.arn
}

output "static_bucket_regional_domain_name" {
  value = aws_s3_bucket.static.bucket_regional_domain_name
}

output "logs_bucket_arn" {
  value = aws_s3_bucket.logs.arn
}

output "db_endpoint" {
  value = aws_db_instance.this.address
}

output "table_name" {
  value = aws_dynamodb_table.reviews.name
}
