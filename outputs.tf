# Module      : SNS Module
# Description : Terraform SNS module outputs.
output "id" {
  value       = join("", aws_sns_platform_application.default[*].id)
  description = "The ID of the SNS platform application."
}

output "arn" {
  value       = join("", aws_sns_platform_application.default[*].arn)
  description = "The ARN of the SNS platform application."
}

output "topic-id" {
  value       = try(aws_sns_topic.default[0].id, null)
  description = "The ID of the SNS topic."
}

output "topic-arn" {
  value       = local.topic_arn
  description = "The ARN of the created topic or the existing topic supplied with topic_arn."
}

output "topic-name" {
  value       = try(aws_sns_topic.default[0].name, null)
  description = "The name of the created SNS topic."
}

output "topic-owner" {
  value       = try(aws_sns_topic.default[0].owner, null)
  description = "The AWS account ID that owns the created SNS topic."
}

output "beginning-archive-time" {
  value       = try(aws_sns_topic.default[0].beginning_archive_time, null)
  description = "The oldest timestamp from which archived FIFO messages can be replayed."
}

output "subscription-arns" {
  value       = { for key, subscription in aws_sns_topic_subscription.this : key => subscription.arn }
  description = "Map of subscriber keys to SNS subscription ARNs."
}

output "subscription-pending-confirmation" {
  value       = { for key, subscription in aws_sns_topic_subscription.this : key => subscription.pending_confirmation }
  description = "Map indicating whether each subscription is pending confirmation."
}
