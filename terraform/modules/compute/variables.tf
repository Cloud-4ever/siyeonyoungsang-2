variable "name_prefix" { type = string }
variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "private_subnet_ids" { type = list(string) }
variable "target_port" { type = number }
variable "alb_security_group_id" { type = string }
variable "application_sg_id" { type = string }
variable "instance_profile_name" { type = string }
variable "instance_type" { type = string }
variable "desired_capacity" { type = number }
variable "min_size" { type = number }
variable "max_size" { type = number }
variable "secrets_manager_arn" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
