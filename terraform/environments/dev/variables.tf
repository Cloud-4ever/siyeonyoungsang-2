variable "aws_region" {
  type        = string
  description = "AWS region for this environment."
}

variable "project_name" {
  type        = string
  description = "Project or service name used in resource naming."
}

variable "environment" {
  type        = string
  description = "Environment name such as dev, stage, or prod."
}

variable "vpc_cidr" {
  type        = string
  description = "Primary CIDR for the VPC."
}

variable "availability_zones" {
  type        = list(string)
  description = "Two or more AZs used for subnet placement."
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDRs for public subnets."
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDRs for private application subnets."
}

variable "isolated_subnet_cidrs" {
  type        = list(string)
  description = "CIDRs for isolated database subnets."
}

variable "flow_log_retention_in_days" {
  type        = number
  description = "Retention period for VPC Flow Logs in CloudWatch."
  default     = 30
}

variable "flow_log_traffic_type" {
  type        = string
  description = "Traffic type to capture for VPC Flow Logs."
  default     = "ALL"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for the application servers."
}


variable "desired_capacity" {
  type        = number
  description = "Desired ASG instance count."
}

variable "min_size" {
  type        = number
  description = "Minimum ASG size."
}

variable "max_size" {
  type        = number
  description = "Maximum ASG size."
}

variable "app_port" {
  type        = number
  description = "Application listener port."
}

variable "db_name" {
  type        = string
  description = "Initial RDS database name."
}

variable "db_username" {
  type        = string
  description = "Database master username."
}

variable "db_password" {
  type        = string
  description = "Database master password."
  sensitive   = true
}

variable "db_instance_class" {
  type        = string
  description = "RDS instance class."
}

variable "domain_name" {
  type        = string
  description = "Primary service domain used by CloudFront."
}

variable "common_tags" {
  type        = map(string)
  description = "Tags shared across all resources."
  default     = {}
}
