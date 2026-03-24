variable "name_prefix" { type = string }
variable "log_kms_key_arn" { type = string }
variable "flow_log_bucket_arn" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
