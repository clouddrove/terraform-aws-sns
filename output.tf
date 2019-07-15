output "id" {
	value = concat(
	    aws_sns_platform_application.sns.*.id
	  )[0]
  	description = "The ID of the SNS platform application"
}

output "arn" {
	value = concat(
	    aws_sns_platform_application.sns.*.arn
	  )[0]
  	description = "The ARN of the SNS platform application"
}