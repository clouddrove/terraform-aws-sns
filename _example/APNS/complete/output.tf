output "arn" {
  value       = module.sns.*.arn
  description = "The ARN of the SNS platform application."
}

output "sqs-arn" {
  value       = module.sqs.arn
  description = "The ARN of the SQS queue."
}