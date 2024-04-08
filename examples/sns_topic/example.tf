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
      protocol                        = "https"
      endpoint                        = "https://example.com"
      endpoint_auto_confirms          = false
      raw_message_delivery            = true
      filter_policy                   = ""
      delivery_policy                 = ""
      confirmation_timeout_in_minutes = "60"
    },
    sms = {
      protocol                        = "sms"
      endpoint                        = "+9198xxxxxx"
      endpoint_auto_confirms          = false
      raw_message_delivery            = false
      filter_policy                   = ""
      delivery_policy                 = ""
      confirmation_timeout_in_minutes = "60"
    },

  }

  data_protection_policy = jsonencode(
    {
      Description = "Deny Inbound Address"
      Name        = "DenyInboundEmailAdressPolicy"
      Statement = [
        {
          "DataDirection" = "Inbound"
          "DataIdentifier" = [
            "arn:aws:dataprotection::aws:data-identifier/EmailAddress",
          ]
          "Operation" = {
            "Deny" = {}
          }
          "Principal" = [
            "*",
          ]
          "Sid" = "DenyInboundEmailAddress"
        },
      ]
      Version = "2021-06-01"
    }
  )
}
