output "arn" {
  value       = module.sns[*].topic-arn
  description = "The ARN of the SNS platform application."
}
