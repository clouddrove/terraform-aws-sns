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

  data_protection_policy = jsonencode({
    Description = "Deny inbound email addresses"
    Name        = "DenyInboundEmailAddressPolicy"
    Statement = [{
      DataDirection = "Inbound"
      DataIdentifier = [
        "arn:aws:dataprotection::aws:data-identifier/EmailAddress",
      ]
      Operation = { Deny = {} }
      Principal = ["*"]
      Sid       = "DenyInboundEmailAddress"
    }]
    Version = "2021-06-01"
  })
}
