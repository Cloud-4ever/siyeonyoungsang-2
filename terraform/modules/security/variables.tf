variable "name_prefix" { type = string }
variable "vpc_id" { type = string }
variable "app_port" { type = number }
variable "region" { type = string }
variable "kms_secret_map" {
  type    = map(string)
  default = {}
}
variable "tags" {
  type    = map(string)
  default = {}
}
