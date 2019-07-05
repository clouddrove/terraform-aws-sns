## Managed By : CloudDrove
## Copyright @ CloudDrove. All Right Reserved.

resource "aws_sns_platform_application" "sns" {
  count = 1
  name                = var.name
  platform            = var.platform
  platform_credential = var.key
  platform_principal  = var.certificate
  event_delivery_failure_topic_arn = var.event_delivery_failure_topic_arn 
  event_endpoint_created_topic_arn = var.event_endpoint_created_topic_arn 
  event_endpoint_deleted_topic_arn = var.event_endpoint_deleted_topic_arn 
  event_endpoint_updated_topic_arn = var.event_endpoint_updated_topic_arn 
  failure_feedback_role_arn = var.failure_feedback_role_arn 
  success_feedback_role_arn = var.success_feedback_role_arn 
  success_feedback_sample_rate = var.success_feedback_sample_rate 
}

resource "aws_sns_topic" "topics" {
  name = var.topic_name
  display_name = var.display_name
  policy = var.policy
  delivery_policy = var.delivery_policy
  application_success_feedback_role_arn = var.application_success_feedback_role_arn
  application_success_feedback_sample_rate = var.application_success_feedback_sample_rate
  application_failure_feedback_role_arn = var.application_failure_feedback_role_arn
  http_success_feedback_role_arn = var.http_success_feedback_role_arn
  http_success_feedback_sample_rate = var.http_success_feedback_sample_rate
  http_failure_feedback_role_arn = var.http_failure_feedback_role_arn
  kms_master_key_id = var.kms_master_key_id
  lambda_success_feedback_role_arn = var.lambda_success_feedback_role_arn
  lambda_success_feedback_sample_rate = var.lambda_success_feedback_sample_rate
  lambda_failure_feedback_role_arn = var.lambda_failure_feedback_role_arn
  sqs_success_feedback_role_arn = var.sqs_success_feedback_role_arn
  sqs_success_feedback_sample_rate = var.sqs_success_feedback_sample_rate
  sqs_failure_feedback_role_arn = var.sqs_failure_feedback_role_arn
}

resource "aws_sns_topic_subscription" "sns-topic" {
  topic_arn = aws_sns_topic.topics.arn
  protocol  = var.protocol
  endpoint  = var.endpoint
  endpoint_auto_confirms  = var.endpoint_auto_confirms
  confirmation_timeout_in_minutes  = var.confirmation_timeout_in_minutes
  raw_message_delivery  = var.raw_message_delivery
  filter_policy  = var.filter_policy
  delivery_policy  = var.subscription_delivery_policy
}

resource "aws_sns_sms_preferences" "update_sms_prefs" {
  count = var.update_preference ? 1 : 0
  delivery_status_iam_role_arn = var.delivery_status_iam_role_arn
  delivery_status_success_sampling_rate = var.delivery_status_success_sampling_rate
  default_sender_id = var.default_sender_id
  default_sms_type = var.default_sms_type
  usage_report_s3_bucket = var.usage_report_s3_bucket
}
