variable "name_prefix" { type = string }
variable "static_bucket_arn" { type = string }
variable "static_bucket_regional_domain_name" { type = string }
variable "alb_dns_name" { type = string }
variable "web_acl_arn" {
  type    = string
  default = null
}
variable "tags" {
  type    = map(string)
  default = {}
}
