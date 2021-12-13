
provider "aws" {
    region = "us-east-2"
}

resource "aws_cloudformation_stack_set" "sophos-cloud-optix" {
    name = "${var.namespace}-${var.stage}-${var.name}"
    permission_model = "SERVICE_MANAGED"
    auto_deployment {
        enabled = true
    }
    template_url       = var.template_url

    parameters = {
        ExternalId                    = "${var.external_id}"
        CustomerId                    = "${var.customer_id}"
        DnsPrefixFlow                 = "${var.dns_prefix_flow}"
        DnsPrefixCloudTrail           = "${var.dns_prefix_cloudtrail}"
        ReqID                         = "${var.req_id}"
        CloudTrailBucket              = "${var.cloud_trail_bucket}"
        CloudTrailBucketFolder        = "${var.cloud_trail_bucket_folder}"
        CloudtrailSNSTopic            = "${var.cloud_trail_sns_topic}"
        OptixResourceKey              = "${var.resource_key}"
        OptixResourceValue            = "${var.resource_value}"
        SophosOptixAccountId          = "${var.sophos_optix_account_id}"
        UseExistingResources          = "${var.existing_resources}"
        IsOrganizationTrail           = "${var.is_organization_trail}"
        EnableCloudtrailLogs          = "${var.enable_cloudtrail_logs}"
        EnableFlowLogs                = "${var.enable_flow_logs}"
        EnableFlowOneRegion           = "${var.enable_flow_logs_one_region}"
        FlowOneRegionValue            = "${var.flow_one_region_value}"
        FlowRegionList                = "${var.flow_region_list}"
        FlowLogsS3RetentionPeriod     = "${var.s3_flowlog_retention}"
        CloudtrailS3RetentionPeriod   = "${var.s3_retention_period}"
        EnableSpendMonitoring         = "${var.enable_spend_monitoring}"
        RandomTrigger                 = "${var.random_trigger}"
    }

    capabilities = ["CAPABILITY_IAM","CAPABILITY_NAMED_IAM"]
}