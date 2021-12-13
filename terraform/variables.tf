variable "external_id" {
    description = "value comes from optix console"
    sensitive = true
}
variable "customer_id" {
    description = "value comes from optix console."
    sensitive = true
}
variable "dns_prefix_flow" {
    default = "flow.optix.sophos.com"
}
variable "dns_prefix_cloudtrail" {
    default = "events.optix.sophos.com"
}
variable "cloud_trail_bucket" {
    default = "aws-cloudtrail-logs-693051501776-e66e6126"
}
variable "cloud_trail_bucket_folder" {
    default = "sophos-optix-cloudtrail/"
}
variable "cloud_trail_sns_topic" {
    default = "Sophos-Optix-flowlogs-s3-sns-topic"
}
variable "resource_key" {
    default = "created_by"
}
variable "resource_value" {
    default = "optix"
}
variable "sophos_optix_account_id" {
    sensitive = true
}
variable "existing_resources" {
    type = bool
    default = true
}
variable "is_organization_trail" {
    type = bool
    default = true
}
variable "enable_cloudtrail_logs" {
    type = bool
    default = true
}
variable "enable_flow_logs" {
    type = bool
    default = true
}
variable "enable_flow_logs_one_region" {
    type = bool
    default = false
}
variable "flow_one_region_value" {
    default = "us-west-2"
}
variable "flow_region_list" {
    type = string
    default = "us-east-1,us-east-2,us-west-1,us-west-2"
}
variable "s3_flowlog_retention" {
    default = 1
}
variable "s3_set_flowlog_retention" {
    type = bool
    default = true
}
variable "s3_retention_period" {
    default = 90
}
variable "s3_set_retention_cloudtrail" {
    default = 90
}
variable "enable_spend_monitoring" {
    type = bool
    default = true
}
variable "random_trigger" {
    default = "new"
}
variable "req_id" {
    default = ""
    sensitive = true
}
variable "account_id" {
    default = ""
    sensitive = true
}
variable "administration_role_arn" {
    sensitive = true
    default = ""
}
variable "namespace" {
    default = ""
}
variable "stage" {
    default = ""
}
variable "name" {
    default = ""
}
variable "template_url" {}
variable "default_region" {}
variable "role_arn" {
    sensitive = true
}
variable "target_account_id" {}
