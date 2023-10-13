provider "aws" {
  region = "eu-west-1"
}

locals {
  name        = "text"
  environment = "test"
}

##-----------------------------------------------------------------------------
## SNS module call.
##-----------------------------------------------------------------------------
module "sns" {
  source = "./../../../"

  name                  = local.name
  environment           = local.environment
  enable_sms_preference = true
  monthly_spend_limit   = "1"

  delivery_status_success_sampling_rate = "50"
  default_sender_id                     = "test"
  default_sms_type                      = "Transactional"
}
