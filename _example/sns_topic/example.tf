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
      endpoint                        = "917414xxxxxx"
      endpoint_auto_confirms          = false
      raw_message_delivery            = false
      filter_policy                   = ""
      delivery_policy                 = ""
      confirmation_timeout_in_minutes = "60"
    },

  }
}

