variable "name" {
  type        = string
  description = "The friendly name for the SNS platform application"
}

variable "platform" {
  type        = string
  default     = ""
  description = "The platform that the app is registered with. See Platform for supported platforms like 'APNS' 'GCM'"
}

variable "key" {
  type        = string
  default     = ""
  description = "Application Platform credential. See Credential for type of credential required for platform. The value of this attribute when stored into the Terraform state is only a hash of the real value, so therefore it is not practical to use this as an attribute for other resources"
}

variable "certificate" {
  type        = string
  default     = ""
  description = "application Platform principal. See Principal for type of principal required for platform. The value of this attribute when stored into the Terraform state is only a hash of the real value, so therefore it is not practical to use this as an attribute for other resources"
}

variable "event_delivery_failure_topic_arn" {
  type        = string
  default     = ""
  description = "SNS Topic triggered when a delivery to any of the platform endpoints associated with your platform application encounters a permanent failure."
}

variable "event_endpoint_created_topic_arn" {
  type        = string
  default     = ""
  description = "SNS Topic triggered when a new platform endpoint is added to your platform application."
}

variable "event_endpoint_deleted_topic_arn" {
  type        = string
  default     = ""
  description = "SNS Topic triggered when an existing platform endpoint is deleted from your platform application."
}

variable "event_endpoint_updated_topic_arn" {
  type        = string
  default     = ""
  description = " SNS Topic triggered when an existing platform endpoint is changed from your platform application."
}

variable "failure_feedback_role_arn" {
  type        = string
  default     = ""
  description = "The IAM role permitted to receive failure feedback for this application."
}

variable "platform_principal" {
  type        = string
  default     = ""
  description = "Application Platform principal. See Principal for type of principal required for platform. The value of this attribute when stored into the Terraform state is only a hash of the real value, so therefore it is not practical to use this as an attribute for other resources."
}

variable "success_feedback_role_arn" {
  type        = string
  default     = ""
  description = "The IAM role permitted to receive success feedback for this application."
}

variable "success_feedback_sample_rate" {
  type        = number
  default     = 100
  description = "The percentage of success to sample (0-100)"
}

variable "topic_name" {
  type        = string
  default     = ""
  description = "The friendly name for the SNS topic. By default generated by Terraform."
}

variable "name_prefix" {
  type        = string
  default     = ""
  description = "The friendly name for the SNS topic. Conflicts with name."
}

variable "display_name" {
  type        = string
  default     = ""
  description = "The display name for the SNS topic."
}

variable "policy" {
  type        = string
  default     = ""
  description = "The fully-formed AWS policy as JSON. For more information about building AWS IAM policy documents with Terraform."
}

variable "delivery_policy" {
  type        = string
  default     = ""
  description = "The SNS delivery policy."
}

variable "application_success_feedback_role_arn" {
  type        = string
  default     = ""
  description = "The IAM role permitted to receive success feedback for this topic."
}

variable "application_success_feedback_sample_rate" {
  type        = number
  default     = 100
  description = "Percentage of success to sample."
}

variable "application_failure_feedback_role_arn" {
  type        = string
  default     = ""
  description = "IAM role for failure feedback."
}

variable "http_success_feedback_role_arn" {
  type        = string
  default     = ""
  description = "The IAM role permitted to receive success feedback for this topic."
}

variable "http_success_feedback_sample_rate" {
  type        = number
  default     = 100
  description = "Percentage of success to sample."
}

variable "http_failure_feedback_role_arn" {
  type        = string
  default     = ""
  description = "IAM role for failure feedback."
}

variable "kms_master_key_id" {
  type        = string
  default     = ""
  description = "The ID of an AWS-managed customer master key (CMK) for Amazon SNS or a custom CMK. For more information."
}

variable "lambda_success_feedback_role_arn" {
  type        = string
  default     = ""
  description = "The IAM role permitted to receive success feedback for this topic."
}

variable "lambda_success_feedback_sample_rate" {
  type        = number
  default     = 100
  description = "Percentage of success to sample."
}

variable "lambda_failure_feedback_role_arn" {
  type        = string
  default     = ""
  description = "IAM role for failure feedback."
}

variable "sqs_success_feedback_role_arn" {
  type        = string
  default     = ""
  description = "The IAM role permitted to receive success feedback for this topic."
}

variable "sqs_success_feedback_sample_rate" {
  type        = number
  default     = 100
  description = "Percentage of success to sample."
}

variable "sqs_failure_feedback_role_arn" {
  type        = string
  default     = ""
  description = "IAM role for failure feedback."
}

variable "protocol" {
  type        = string
  default     = ""
  description = "The protocol to use. The possible values for this are: sqs, sms, lambda, application"
}

variable "endpoint" {
  type        = string
  default     = ""
  description = "The endpoint to send data to, the contents will vary with the protocol."
}

variable "endpoint_auto_confirms" {
  default     = false
  description = "Boolean indicating whether the end point is capable of auto confirming subscription."
}

variable "confirmation_timeout_in_minutes" {
  type        = number
  default     = 60
  description = " Integer indicating number of minutes to wait in retying mode for fetching subscription arn before marking it as failure. Only applicable for http and https protocols."
}

variable "raw_message_delivery" {
  default     = false
  description = "Boolean indicating whether or not to enable raw message delivery."
}

variable "filter_policy" {
  default     = ""
  description = "JSON String with the filter policy that will be used in the subscription to filter messages seen by the target resource."
}

variable "subscription_delivery_policy" {
  default     = ""
  description = "JSON String with the delivery policy (retries, backoff, etc.) that will be used in the subscription - this only applies to HTTP/S subscriptions."
}

variable "update_preference" {
  default     = false
  description = "Boolean indicating whether or not to update SNS SMS Preference."
}

variable "create_topic" {
  default     = false
  description = "Boolean indicating whether or not to create topic."
}

variable "monthly_spend_limit" {
  default     = 1
  description = "The maximum amount in USD that you are willing to spend each month to send SMS messages."
}

variable "delivery_status_iam_role_arn" {
  type        = string
  default     = ""
  description = "The ARN of the IAM role that allows Amazon SNS to write logs about SMS deliveries in CloudWatch Logs."
}

variable "delivery_status_success_sampling_rate" {
  default     = 50
  description = "The percentage of successful SMS deliveries for which Amazon SNS will write logs in CloudWatch Logs. The value must be between 0 and 100."
}

variable "default_sender_id" {
  type        = string
  default     = ""
  description = "A string, such as your business brand, that is displayed as the sender on the receiving device."
}

variable "default_sms_type" {
  type        = string
  default     = "Transactional"
  description = "The type of SMS message that you will send by default. Possible values are: Promotional, Transactional."
}

variable "usage_report_s3_bucket" {
  type        = string
  default     = ""
  description = "The name of the Amazon S3 bucket to receive daily SMS usage reports from Amazon SNS."
}