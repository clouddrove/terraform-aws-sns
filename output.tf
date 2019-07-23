output "id" {
  value = concat(
    aws_sns_platform_application.default.*.id
  )[0]
  description = "The ID of the SNS platform application"
}

output "arn" {
  value = concat(
    aws_sns_platform_application.default.*.arn
  )[0]
  description = "The ARN of the SNS platform application"
}