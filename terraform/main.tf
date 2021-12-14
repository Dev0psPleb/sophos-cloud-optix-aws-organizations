# S3 Remote Backend
terraform {
    backend "s3" {
        bucket = "terraform-optix-stackset-693051501776"
        key = "terraform"
        region = "us-east-2"
    }
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.69.0"
        }
    }
}

provider "aws" {
    assume_role {
        role_arn = var.role_arn
    }
    region = var.default_region
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

resource "aws_cloudformation_stack_set_instance" "instance" {
    region              = var.default_region
    stack_set_name      = aws_cloudformation_stack_set.sophos-cloud-optix.name
    
    deployment_targets {
        organizational_unit_ids = var.target_ous
    }

    depends_on = [
        aws_cloudformation_stack_set.sophos-cloud-optix
    ]
}