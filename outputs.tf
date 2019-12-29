#Module      : SNS
#Description : Terraform module is used to setup SNS service to manage notifications on application.
output "id" {
  value       = join("", aws_sns_platform_application.default.*.id)
  description = "The ID of the SNS platform application."
}

output "arn" {
  value       = join("", aws_sns_platform_application.default.*.arn)
  description = "The ARN of the SNS platform application."
}