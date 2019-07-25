output "arn" {
  value       = module.sns.*.arn
  description = "The ARN of the SNS platform application"
}