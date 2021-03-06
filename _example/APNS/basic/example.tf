provider "aws" {
  region = "eu-west-1"
}

module "sns" {
  source = "./../../../"

  name        = "basic-sns"
  environment = "test"
  label_order = ["name", "environment"]

  enable_sns  = true
  platform    = "APNS"
  key         = "../../certificates/private_key.pem"
  certificate = "../../certificates/cert.pem"
}
