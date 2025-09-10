#Module      : LABEL
#Description : Terraform label module variables
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "repository" {
  type        = string
  default     = "https://github.com/clouddrove/terraform-aws-sns"
  description = "Terraform current module repo"
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment"]
  description = "Label order, e.g. `name`,`application`."
}

variable "managedby" {
  type        = string
  default     = "hello@clouddrove.com"
  description = "ManagedBy, eg 'CloudDrove'."
}

# Module      : SNS Module
# Description : Terraform SNS module variables
variable "enabled" {
  type        = bool
  default     = true
  description = "Boolean indicating whether or not to create sns module."
}

variable "platform" {
  type        = string
  default     = ""
  description = "The platform that the app is registered with. See Platform for supported platforms like 'APNS' 'GCM'."
}

variable "key" {
  type        = string
  default     = ""
  description = "Application Platform credential. See Credential for type of credential required for platform. The value of this attribute when stored into the Terraform state is only a hash of the real value, so therefore it is not practical to use this as an attribute for other resources."
}
variable "gcm_key" {
  type        = string
  default     = ""
  description = "Application Platform credential. See Credential for type of credential required for platform. The value of this attribute when stored into the Terraform state is only a hash of the real value, so therefore it is not practical to use this as an attribute for other resources."
  sensitive   = true
}

variable "certificate" {
  type        = string
  default     = ""
  description = "application Platform principal. See Principal for type of principal required for platform. The value of this attribute when stored into the Terraform state is only a hash of the real value, so therefore it is not practical to use this as an attribute for other resources."
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
  description = "SNS Topic triggered when an existing platform endpoint is changed from your platform application."
}

variable "failure_feedback_role_arn" {
  type        = string
  default     = ""
  description = "The IAM role permitted to receive failure feedback for this application."
}

variable "success_feedback_role_arn" {
  type        = string
  default     = ""
  description = "The IAM role permitted to receive success feedback for this application."
  sensitive   = true
}

variable "success_feedback_sample_rate" {
  type        = number
  default     = 100
  description = "The percentage of success to sample (0-100)."
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
  default     = null
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
  sensitive   = true
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

variable "enable_sms_preference" {
  type        = bool
  default     = false
  description = "Boolean indicating whether or not to update SNS SMS Preference."
}

variable "enable_topic" {
  type        = bool
  default     = false
  description = "Boolean indicating whether or not to create topic."
}

variable "enable_sns" {
  type        = bool
  default     = false
  description = "Boolean indicating whether or not to create sns."
}

variable "monthly_spend_limit" {
  type        = number
  default     = 1
  description = "The maximum amount in USD that you are willing to spend each month to send SMS messages."
}

variable "delivery_status_iam_role_arn" {
  type        = string
  default     = ""
  description = "The ARN of the IAM role that allows Amazon SNS to write logs about SMS deliveries in CloudWatch Logs."
  sensitive   = true
}

variable "delivery_status_success_sampling_rate" {
  type        = number
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

variable "subscribers" {
  type = map(object({
    protocol = string
    # The protocol to use. The possible values for this are: sqs, sms, lambda, application. (http or https are partially supported, see below) (email is an option but is unsupported, see below).
    endpoint = string
    # The endpoint to send data to, the contents will vary with the protocol. (see below for more information)
    endpoint_auto_confirms = bool
    # Boolean indicating whether the end point is capable of auto confirming subscription e.g., PagerDuty (default is false)
    raw_message_delivery = bool
    # Boolean indicating whether or not to enable raw message delivery (the original message is directly passed, not wrapped in JSON with the original message in the message property) (default is false)
    filter_policy = string
    # JSON String with the filter policy that will be used in the subscription to filter messages seen by the target resource.
    delivery_policy = string
    # The SNS delivery policy
    confirmation_timeout_in_minutes = string
    # Integer indicating number of minutes to wait in retying mode for fetching subscription arn before marking it as failure. Only applicable for http and https protocols.
    redrive_policy = string
    # When specified, sends undeliverable messages to the specified SQS dead-letter queue
    replay_policy = string
    # A map of replay policy statements
    subscription_role_arn = string
    # The ARN of the IAM role that has the following trust relationship policy: { "Version": "2012-10-17", "Statement": [ { "Effect": "Allow", "Principal": { "Service": "sns.amazonaws.com" }, "Action": "sts:AssumeRole" } ] }
  }))
  description = "Required configuration for subscibres to SNS topic."
  default     = {}
}

variable "content_based_deduplication" {
  type        = bool
  default     = false
  description = "Boolean indicating whether or not to enable content-based deduplication for FIFO topics."
}

variable "signature_version" {
  type        = number
  default     = null
  description = "If SignatureVersion should be 1 (SHA1) or 2 (SHA256). The signature version corresponds to the hashing algorithm used while creating the signature of the notifications, subscription confirmations, or unsubscribe confirmation messages sent by Amazon SNS."
}

variable "tracing_config" {
  type        = string
  default     = null
  description = "Tracing mode of an Amazon SNS topic. Valid values: PassThrough, Active."
}

variable "create_topic_policy" {
  type        = bool
  default     = true
  description = "Determines whether an SNS topic policy is created"
}

variable "source_topic_policy_documents" {
  type        = list(string)
  default     = []
  description = "List of IAM policy documents that are merged together into the exported document. Statements must have unique `sid`s"
}

variable "override_topic_policy_documents" {
  type        = list(string)
  default     = []
  description = "List of IAM policy documents that are merged together into the exported document. In merging, statements with non-blank `sid`s will override statements with the same `sid`"
}

variable "enable_default_topic_policy" {
  type        = bool
  default     = true
  description = "Specifies whether to enable the default topic policy. Defaults to `true`"
}

variable "topic_policy_statements" {
  type        = any
  default     = {}
  description = "A map of IAM policy [statements](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#statement) for custom permission usage"
}

variable "fifo_topic" {
  type        = bool
  default     = false
  description = "Boolean indicating whether or not to create a FIFO (first-in-first-out) topic"
}

variable "data_protection_policy" {
  type        = string
  default     = null
  description = "A map of data protection policy statements"
}
