provider "aws" {
  region = "eu-west-1"
}

module "sns" {
  source = "./../../"

  name        = "sqs"
  environment = "test"
  label_order = ["name", "environment"]
  enable_topic = true
}

