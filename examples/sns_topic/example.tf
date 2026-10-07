provider "aws" {
  region = "eu-west-1"
}

locals {
  name        = "sqs"
  environment = "test"
}

##-----------------------------------------------------------------------------
## SNS module call.
##-----------------------------------------------------------------------------
module "sns" {
  source = "./../../"

  name         = local.name
  environment  = local.environment
  enable_topic = true

  subscribers = {
    newrelic = {
      protocol             = "https"
      endpoint             = "https://example.com"
      raw_message_delivery = true
      filter_policy        = jsonencode({ event_type = ["created"] })
      filter_policy_scope  = "MessageBody"
    },
    sms = {
      protocol = "sms"
      endpoint = "+919876543210"
    },

  }

}
