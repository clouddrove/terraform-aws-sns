## Managed By : CloudDrove
## Copyright @ CloudDrove. All Right Reserved.

resource "aws_sns_platform_application" "sns" {
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
