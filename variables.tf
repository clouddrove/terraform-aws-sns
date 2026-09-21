#Module      : LABEL
#Description : Terraform label module variables
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "extra_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)."
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

variable "platform_credential" {
  type        = string
  default     = null
  description = "Platform credential value supplied directly. Takes precedence over gcm_key and the file referenced by key."
  sensitive   = true
}

variable "platform_principal" {
  type        = string
  default     = null
  description = "Platform principal value supplied directly. Takes precedence over the file referenced by certificate. For APNS token authentication, use the signing key ID."
  sensitive   = true
}

variable "apple_platform_team_id" {
  type        = string
  default     = null
  description = "Ten-character Apple developer team ID used for APNS token-based authentication."

  validation {
    condition     = var.apple_platform_team_id == null || can(regex("^[[:alnum:]]{10}$", var.apple_platform_team_id))
    error_message = "apple_platform_team_id must contain exactly 10 alphanumeric characters."
  }
}

variable "apple_platform_bundle_id" {
  type        = string
  default     = null
  description = "Apple application bundle ID used for APNS token-based authentication."

  validation {
    condition     = var.apple_platform_bundle_id == null || can(regex("^[[:alnum:].-]+$", var.apple_platform_bundle_id))
    error_message = "apple_platform_bundle_id may contain only alphanumeric characters, hyphens, and periods."
  }
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
  description = "Fully formed topic policy JSON used when create_topic_policy is false."
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

variable "firehose_success_feedback_role_arn" {
  type        = string
  default     = null
  description = "IAM role that permits SNS to write successful Amazon Data Firehose delivery logs to CloudWatch Logs."
}

variable "firehose_success_feedback_sample_rate" {
  type        = number
  default     = null
  description = "Percentage of successful Amazon Data Firehose deliveries to log, from 0 to 100."

  validation {
    condition     = var.firehose_success_feedback_sample_rate == null || (var.firehose_success_feedback_sample_rate >= 0 && var.firehose_success_feedback_sample_rate <= 100)
    error_message = "firehose_success_feedback_sample_rate must be between 0 and 100."
  }
}

variable "firehose_failure_feedback_role_arn" {
  type        = string
  default     = null
  description = "IAM role that permits SNS to write failed Amazon Data Firehose delivery logs to CloudWatch Logs."
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

variable "topic_arn" {
  type        = string
  default     = null
  description = "ARN of an existing SNS topic to which subscribers are attached when enable_topic is false."

  validation {
    condition     = var.topic_arn == null || can(regex("^arn:[^:]+:sns:[^:]+:[0-9]{12}:.+$", var.topic_arn))
    error_message = "topic_arn must be a valid SNS topic ARN."
  }
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
    endpoint_auto_confirms = optional(bool, false)
    # Boolean indicating whether the end point is capable of auto confirming subscription e.g., PagerDuty (default is false)
    raw_message_delivery = optional(bool, false)
    # Boolean indicating whether or not to enable raw message delivery (the original message is directly passed, not wrapped in JSON with the original message in the message property) (default is false)
    filter_policy = optional(string)
    # JSON String with the filter policy that will be used in the subscription to filter messages seen by the target resource.
    filter_policy_scope = optional(string)
    # Whether the filter policy applies to MessageAttributes or MessageBody.
    delivery_policy = optional(string)
    # The SNS delivery policy
    confirmation_timeout_in_minutes = optional(number, 1)
    # Integer indicating number of minutes to wait in retying mode for fetching subscription arn before marking it as failure. Only applicable for http and https protocols.
    redrive_policy = optional(string)
    # When specified, sends undeliverable messages to the specified SQS dead-letter queue
    replay_policy = optional(string)
    # A map of replay policy statements
    subscription_role_arn = optional(string)
    # The ARN of the IAM role that has the following trust relationship policy: { "Version": "2012-10-17", "Statement": [ { "Effect": "Allow", "Principal": { "Service": "sns.amazonaws.com" }, "Action": "sts:AssumeRole" } ] }
  }))
  description = "SNS topic subscriptions. Only protocol and endpoint are required; optional settings configure delivery, filtering, dead-letter queues, replay, and Firehose access."
  default     = {}

  validation {
    condition = alltrue([
      for subscriber in values(var.subscribers) : contains(
        ["application", "email", "email-json", "firehose", "http", "https", "lambda", "sms", "sqs"],
        subscriber.protocol,
      )
    ])
    error_message = "Each subscriber protocol must be one supported by Amazon SNS."
  }

  validation {
    condition = alltrue([
      for subscriber in values(var.subscribers) : subscriber.filter_policy_scope == null || contains(["MessageAttributes", "MessageBody"], subscriber.filter_policy_scope)
    ])
    error_message = "Each filter_policy_scope must be MessageAttributes or MessageBody."
  }

  validation {
    condition = alltrue([
      for subscriber in values(var.subscribers) : subscriber.protocol != "firehose" || subscriber.subscription_role_arn != null
    ])
    error_message = "A subscription_role_arn is required for every firehose subscriber."
  }
}

variable "content_based_deduplication" {
  type        = bool
  default     = false
  description = "Boolean indicating whether or not to enable content-based deduplication for FIFO topics."
}

variable "fifo_throughput_scope" {
  type        = string
  default     = null
  description = "FIFO throughput and deduplication scope. Valid values are Topic and MessageGroup; MessageGroup enables high throughput and cannot later be changed back to Topic."

  validation {
    condition     = var.fifo_throughput_scope == null || contains(["Topic", "MessageGroup"], var.fifo_throughput_scope)
    error_message = "fifo_throughput_scope must be Topic or MessageGroup."
  }
}

variable "archive_policy" {
  type        = string
  default     = null
  description = "JSON archive policy for FIFO topics. MessageRetentionPeriod must be between 1 and 365 days. Disable archiving before destroying a topic."

  validation {
    condition = var.archive_policy == null || (
      can(jsondecode(var.archive_policy).MessageRetentionPeriod) &&
      try(jsondecode(var.archive_policy).MessageRetentionPeriod >= 1, false) &&
      try(jsondecode(var.archive_policy).MessageRetentionPeriod <= 365, false)
    )
    error_message = "archive_policy must be valid JSON containing MessageRetentionPeriod between 1 and 365."
  }
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
  description = "JSON data protection policy for a standard topic. AWS no longer makes SNS message data protection available to new customers as of April 30, 2026."
}
