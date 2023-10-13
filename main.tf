data "aws_caller_identity" "current" {}

##-----------------------------------------------------------------------------
## Labels module callled that will be used for naming and tags.
##-----------------------------------------------------------------------------
module "labels" {
  source      = "clouddrove/labels/aws"
  version     = "1.3.0"
  name        = var.name
  repository  = var.repository
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
}

##-----------------------------------------------------------------------------
## Creates a platform application object for one of the supported push notification services, such as APNS and GCM (Firebase Cloud Messaging), to which devices and mobile apps may register.
##-----------------------------------------------------------------------------
resource "aws_sns_platform_application" "default" {
  count                            = var.enabled && var.enable_sns ? 1 : 0
  name                             = module.labels.id
  platform                         = var.platform
  platform_credential              = length(var.gcm_key) > 0 ? var.gcm_key : file(var.key)
  platform_principal               = length(var.gcm_key) > 0 ? var.gcm_key : file(var.certificate)
  event_delivery_failure_topic_arn = var.event_delivery_failure_topic_arn
  event_endpoint_created_topic_arn = var.event_endpoint_created_topic_arn
  event_endpoint_deleted_topic_arn = var.event_endpoint_deleted_topic_arn
  event_endpoint_updated_topic_arn = var.event_endpoint_updated_topic_arn
  failure_feedback_role_arn        = var.failure_feedback_role_arn
  success_feedback_role_arn        = var.success_feedback_role_arn
  success_feedback_sample_rate     = var.success_feedback_sample_rate
}

##-----------------------------------------------------------------------------
## Amazon Simple Notification Service (Amazon SNS) coordinates and manages the delivery or sending of messages to subscribing endpoints or clients.
##-----------------------------------------------------------------------------
#tfsec:ignore:aws-sns-enable-topic-encryption
resource "aws_sns_topic" "default" {
  count                                    = var.enabled && var.enable_topic ? 1 : 0
  name                                     = module.labels.id
  display_name                             = var.display_name
  policy                                   = var.policy
  delivery_policy                          = var.delivery_policy
  application_success_feedback_role_arn    = var.application_success_feedback_role_arn
  application_success_feedback_sample_rate = var.application_success_feedback_sample_rate
  application_failure_feedback_role_arn    = var.application_failure_feedback_role_arn
  http_success_feedback_role_arn           = var.http_success_feedback_role_arn
  http_success_feedback_sample_rate        = var.http_success_feedback_sample_rate
  http_failure_feedback_role_arn           = var.http_failure_feedback_role_arn
  kms_master_key_id                        = var.kms_master_key_id
  lambda_success_feedback_role_arn         = var.lambda_success_feedback_role_arn
  lambda_success_feedback_sample_rate      = var.lambda_success_feedback_sample_rate
  lambda_failure_feedback_role_arn         = var.lambda_failure_feedback_role_arn
  sqs_success_feedback_role_arn            = var.sqs_success_feedback_role_arn
  sqs_success_feedback_sample_rate         = var.sqs_success_feedback_sample_rate
  sqs_failure_feedback_role_arn            = var.sqs_failure_feedback_role_arn
  content_based_deduplication              = var.content_based_deduplication
  fifo_topic                               = var.fifo_topic
  signature_version                        = var.fifo_topic ? null : var.signature_version
  tracing_config                           = var.tracing_config
  tags                                     = module.labels.tags
}

##-----------------------------------------------------------------------------
## rovides a resource for subscribing to SNS topics. Requires that an SNS topic exist for the subscription to attach to.
##-----------------------------------------------------------------------------
resource "aws_sns_topic_subscription" "this" {
  for_each                        = var.subscribers
  topic_arn                       = join("", aws_sns_topic.default[*].arn)
  protocol                        = var.subscribers[each.key].protocol
  endpoint                        = var.subscribers[each.key].endpoint
  endpoint_auto_confirms          = var.subscribers[each.key].endpoint_auto_confirms
  raw_message_delivery            = var.subscribers[each.key].raw_message_delivery
  filter_policy                   = var.subscribers[each.key].filter_policy
  delivery_policy                 = var.subscribers[each.key].delivery_policy
  confirmation_timeout_in_minutes = var.subscribers[each.key].confirmation_timeout_in_minutes
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
  count  = var.enabled && var.create_topic_policy ? 1 : 0
  arn    = aws_sns_topic.default[0].arn
  policy = data.aws_iam_policy_document.this[0].json
}

data "aws_iam_policy_document" "this" {
  count = var.enabled && var.create_topic_policy ? 1 : 0

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
        values   = [data.aws_caller_identity.current.account_id]
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
  count  = var.enabled && var.data_protection_policy != null && !var.fifo_topic ? 1 : 0
  arn    = aws_sns_topic.default[0].arn
  policy = var.data_protection_policy
}
