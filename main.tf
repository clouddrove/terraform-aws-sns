terraform {
  required_version = ">= 0.12"
}


resource "aws_sns_platform_application" "sns" {
  name                = var.name
  platform            = var.platform
  platform_credential = var.key
  platform_principal  = var.certificate
  success_feedback_sample_rate = 100
}
