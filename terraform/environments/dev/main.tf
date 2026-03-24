locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

module "network" {
  source = "../../modules/network"

  name_prefix                = local.name_prefix
  vpc_cidr                   = var.vpc_cidr
  availability_zones         = var.availability_zones
  public_subnet_cidrs        = var.public_subnet_cidrs
  private_subnet_cidrs       = var.private_subnet_cidrs
  isolated_subnet_cidrs      = var.isolated_subnet_cidrs
  flow_log_retention_in_days = var.flow_log_retention_in_days
  flow_log_traffic_type      = var.flow_log_traffic_type
  tags                       = var.common_tags
}

module "storage" {
  source = "../../modules/storage"

  name_prefix        = local.name_prefix
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
  db_instance_class  = var.db_instance_class
  subnet_ids         = module.network.isolated_subnet_ids
  security_group_ids = [module.security.db_security_group_id]
  kms_key_arn        = module.security.kms_key_arn
  tags               = var.common_tags
}

module "security" {
  source = "../../modules/security"
  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }
  name_prefix = local.name_prefix
  vpc_id      = module.network.vpc_id
  app_port    = var.app_port
  region      = var.aws_region
  kms_secret_map = {
    db_username = var.db_username
    db_password = var.db_password
  }
  tags = var.common_tags
}

module "compute" {
  source = "../../modules/compute"

  name_prefix           = local.name_prefix
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  private_subnet_ids    = module.network.private_subnet_ids
  target_port           = var.app_port
  alb_security_group_id = module.security.alb_security_group_id
  application_sg_id     = module.security.app_security_group_id
  instance_profile_name = module.security.instance_profile_name
  instance_type         = var.instance_type
  desired_capacity      = var.desired_capacity
  min_size              = var.min_size
  max_size              = var.max_size
  secrets_manager_arn   = module.security.secret_arn
  tags                  = var.common_tags
}

module "endpoints" {
  source = "../../modules/endpoints"

  name_prefix                = local.name_prefix
  vpc_id                     = module.network.vpc_id
  route_table_ids            = module.network.private_route_table_ids
  private_subnet_ids         = module.network.private_subnet_ids
  endpoint_security_group_id = module.security.endpoint_security_group_id
  region                     = var.aws_region
  tags                       = var.common_tags
}

module "monitoring" {
  source = "../../modules/monitoring"

  name_prefix         = local.name_prefix
  log_kms_key_arn     = module.security.kms_key_arn
  flow_log_bucket_arn = module.storage.logs_bucket_arn
  tags                = var.common_tags
}

module "edge" {
  source = "../../modules/edge"

  name_prefix                        = local.name_prefix
  static_bucket_arn                  = module.storage.static_bucket_arn
  static_bucket_regional_domain_name = module.storage.static_bucket_regional_domain_name
  alb_dns_name                       = module.compute.alb_dns_name
  web_acl_arn                        = module.security.web_acl_arn
  tags                               = var.common_tags
}
