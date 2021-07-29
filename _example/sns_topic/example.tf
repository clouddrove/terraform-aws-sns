provider "aws" {
  region = "eu-west-1"
}

module "sns" {
  source = "./../../"

  name         = "sqs"
  environment  = "test"
  label_order  = ["name", "environment"]
  enable_topic = true

  subscribers = {
    newrelic = {
      protocol               = "https"
      endpoint               = "https://example.com"
      endpoint_auto_confirms = false
      raw_message_delivery   = true
    },
    sms = {
      protocol               = "sms"
      endpoint               = "917742602140"
      endpoint_auto_confirms = false
      raw_message_delivery   = false
    },

  }
}

