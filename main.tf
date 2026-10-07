data "aws_caller_identity" "current" {
  count = var.enabled && var.enable_topic && var.create_topic_policy && var.enable_default_topic_policy ? 1 : 0
}

locals {
  topic_arn = var.enable_topic ? try(aws_sns_topic.default[0].arn, null) : var.topic_arn

  platform_credential = try(coalesce(
    var.platform_credential,
    var.gcm_key != "" ? var.gcm_key : null,
    var.key != "" ? file(var.key) : null,
  ), null)
  platform_principal = try(coalesce(
    var.platform_principal,
    var.certificate != "" ? file(var.certificate) : null,
  ), null)
}

##-----------------------------------------------------------------------------
## Labels module callled that will be used for naming and tags.
##-----------------------------------------------------------------------------
module "labels" {
  source      = "clouddrove/labels/aws"
  version     = "1.3.1"
  name        = var.name
  repository  = var.repository
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
  extra_tags  = var.extra_tags
}

##-----------------------------------------------------------------------------
## Creates a platform application object for one of the supported push notification services, such as APNS and GCM (Firebase Cloud Messaging), to which devices and mobile apps may register.
##-----------------------------------------------------------------------------
resource "aws_sns_platform_application" "default" {
  count                            = var.enabled && var.enable_sns ? 1 : 0
  name                             = module.labels.id
  platform                         = var.platform
  platform_credential              = local.platform_credential
  platform_principal               = local.platform_principal
  apple_platform_team_id           = var.apple_platform_team_id
  apple_platform_bundle_id         = var.apple_platform_bundle_id
  event_delivery_failure_topic_arn = var.event_delivery_failure_topic_arn
  event_endpoint_created_topic_arn = var.event_endpoint_created_topic_arn
  event_endpoint_deleted_topic_arn = var.event_endpoint_deleted_topic_arn
  event_endpoint_updated_topic_arn = var.event_endpoint_updated_topic_arn
  failure_feedback_role_arn        = var.failure_feedback_role_arn
  success_feedback_role_arn        = var.success_feedback_role_arn
  success_feedback_sample_rate     = var.success_feedback_sample_rate

  lifecycle {
    precondition {
      condition     = local.platform_credential != null
      error_message = "A platform credential must be supplied with platform_credential, gcm_key, or key when enable_sns is true."
    }

    precondition {
      condition     = (var.apple_platform_team_id == null) == (var.apple_platform_bundle_id == null)
      error_message = "apple_platform_team_id and apple_platform_bundle_id must be supplied together for APNS token authentication."
    }

    precondition {
      condition = var.apple_platform_team_id == null || (
        contains(["APNS", "APNS_SANDBOX"], var.platform) && local.platform_principal != null
      )
      error_message = "APNS token authentication requires an APNS platform and platform_principal containing the Apple signing key ID."
    }
  }
}

##-----------------------------------------------------------------------------
## Amazon Simple Notification Service (Amazon SNS) coordinates and manages the delivery or sending of messages to subscribing endpoints or clients.
##-----------------------------------------------------------------------------
#tfsec:ignore:aws-sns-enable-topic-encryption
resource "aws_sns_topic" "default" {
  count                                    = var.enabled && var.enable_topic ? 1 : 0
  name                                     = module.labels.id
  display_name                             = var.display_name
  policy                                   = var.create_topic_policy || var.policy == "" ? null : var.policy
  delivery_policy                          = var.delivery_policy
  application_success_feedback_role_arn    = var.application_success_feedback_role_arn
  application_success_feedback_sample_rate = var.application_success_feedback_sample_rate
  application_failure_feedback_role_arn    = var.application_failure_feedback_role_arn
  http_success_feedback_role_arn           = var.http_success_feedback_role_arn
  http_success_feedback_sample_rate        = var.http_success_feedback_sample_rate
  http_failure_feedback_role_arn           = var.http_failure_feedback_role_arn
  firehose_success_feedback_role_arn       = var.firehose_success_feedback_role_arn
  firehose_success_feedback_sample_rate    = var.firehose_success_feedback_sample_rate
  firehose_failure_feedback_role_arn       = var.firehose_failure_feedback_role_arn
  kms_master_key_id                        = var.kms_master_key_id
  lambda_success_feedback_role_arn         = var.lambda_success_feedback_role_arn
  lambda_success_feedback_sample_rate      = var.lambda_success_feedback_sample_rate
  lambda_failure_feedback_role_arn         = var.lambda_failure_feedback_role_arn
  sqs_success_feedback_role_arn            = var.sqs_success_feedback_role_arn
  sqs_success_feedback_sample_rate         = var.sqs_success_feedback_sample_rate
  sqs_failure_feedback_role_arn            = var.sqs_failure_feedback_role_arn
  content_based_deduplication              = var.content_based_deduplication
  fifo_throughput_scope                    = var.fifo_throughput_scope
  fifo_topic                               = var.fifo_topic
  archive_policy                           = var.archive_policy
  signature_version                        = var.fifo_topic ? null : var.signature_version
  tracing_config                           = var.tracing_config
  tags                                     = module.labels.tags

  lifecycle {
    precondition {
      condition     = var.fifo_topic || (var.fifo_throughput_scope == null && var.archive_policy == null)
      error_message = "fifo_throughput_scope and archive_policy can only be configured for a FIFO topic."
    }
  }
}

##-----------------------------------------------------------------------------
## Provides a resource for subscribing to SNS topics. Requires that an SNS topic exist for the subscription to attach to.
##-----------------------------------------------------------------------------
resource "aws_sns_topic_subscription" "this" {
  for_each = var.enabled && (var.enable_topic || var.topic_arn != null) ? var.subscribers : {}

  topic_arn                       = local.topic_arn
  protocol                        = each.value.protocol
  endpoint                        = each.value.endpoint
  endpoint_auto_confirms          = each.value.endpoint_auto_confirms
  raw_message_delivery            = each.value.raw_message_delivery
  filter_policy                   = each.value.filter_policy
  filter_policy_scope             = each.value.filter_policy_scope
  delivery_policy                 = each.value.delivery_policy
  confirmation_timeout_in_minutes = each.value.confirmation_timeout_in_minutes
  redrive_policy                  = each.value.redrive_policy
  replay_policy                   = each.value.replay_policy
  subscription_role_arn           = each.value.subscription_role_arn
}

##-----------------------------------------------------------------------------
## Provides a way to set SNS SMS preferences.
##-----------------------------------------------------------------------------
resource "aws_sns_sms_preferences" "default" {
  count                                 = var.enabled && var.enable_sms_preference ? 1 : 0
  monthly_spend_limit                   = var.monthly_spend_limit
  delivery_status_iam_role_arn          = var.delivery_status_iam_role_arn
  delivery_status_success_sampling_rate = var.delivery_status_success_sampling_rate
  default_sender_id                     = var.default_sender_id
  default_sms_type                      = var.default_sms_type
  usage_report_s3_bucket                = var.usage_report_s3_bucket
}

##-----------------------------------------------------------------------------
## Provides an SNS topic policy resource..
##-----------------------------------------------------------------------------
resource "aws_sns_topic_policy" "this" {
  # count  = var.enabled && var.create_topic_policy ? 1 : 0
  count  = var.enabled && var.enable_topic && var.create_topic_policy ? 1 : 0
  arn    = aws_sns_topic.default[0].arn
  policy = data.aws_iam_policy_document.this[0].json
}

data "aws_iam_policy_document" "this" {
  # count = var.enabled && var.create_topic_policy ? 1 : 0
  count = var.enabled && var.enable_topic && var.create_topic_policy ? 1 : 0

  source_policy_documents   = var.source_topic_policy_documents
  override_policy_documents = var.override_topic_policy_documents

  dynamic "statement" {
    for_each = var.enable_default_topic_policy ? [1] : []

    content {
      sid = "__default_statement_ID"
      actions = [
        "sns:Subscribe",
        "sns:SetTopicAttributes",
        "sns:RemovePermission",
        "sns:Publish",
        "sns:ListSubscriptionsByTopic",
        "sns:GetTopicAttributes",
        "sns:DeleteTopic",
        "sns:AddPermission",
      ]
      effect    = "Allow"
      resources = [aws_sns_topic.default[0].arn]

      principals {
        type        = "AWS"
        identifiers = ["*"]
      }

      condition {
        test     = "StringEquals"
        values   = [data.aws_caller_identity.current[0].account_id]
        variable = "AWS:SourceOwner"
      }
    }
  }

  dynamic "statement" {
    for_each = var.topic_policy_statements

    content {
      sid         = try(statement.value.sid, statement.key)
      actions     = try(statement.value.actions, null)
      not_actions = try(statement.value.not_actions, null)
      effect      = try(statement.value.effect, null)
      # This avoids the chicken vs the egg scenario since its embedded and can reference the topic
      resources     = try(statement.value.resources, [aws_sns_topic.default[0].arn])
      not_resources = try(statement.value.not_resources, null)

      dynamic "principals" {
        for_each = try(statement.value.principals, [])

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = try(statement.value.not_principals, [])

        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = try(statement.value.conditions, [])

        content {
          test     = condition.value.test
          values   = condition.value.values
          variable = condition.value.variable
        }
      }
    }
  }
}

resource "aws_sns_topic_data_protection_policy" "this" {
  count  = var.enabled && var.enable_topic && var.data_protection_policy != null && !var.fifo_topic ? 1 : 0
  arn    = aws_sns_topic.default[0].arn
  policy = var.data_protection_policy
}
