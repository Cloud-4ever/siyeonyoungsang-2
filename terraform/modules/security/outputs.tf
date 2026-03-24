output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "app_security_group_id" {
  value = aws_security_group.app.id
}

output "db_security_group_id" {
  value = aws_security_group.db.id
}

output "endpoint_security_group_id" {
  value = aws_security_group.endpoint.id
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.this.name
}

output "kms_key_arn" {
  value = aws_kms_key.this.arn
}

output "secret_arn" {
  value = aws_secretsmanager_secret.this.arn
}

output "web_acl_arn" {
  value = aws_wafv2_web_acl.this.arn
}
