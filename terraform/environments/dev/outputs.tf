output "vpc_id" {
  value = module.network.vpc_id
}

output "alb_dns_name" {
  value = module.compute.alb_dns_name
}

output "cloudfront_domain_name" {
  value = module.edge.distribution_domain_name
}

output "rds_endpoint" {
  value = module.storage.db_endpoint
}

output "static_bucket_name" {
  value = module.storage.static_bucket_name
}

output "secret_arn" {
  value     = module.security.secret_arn
  sensitive = true
}
