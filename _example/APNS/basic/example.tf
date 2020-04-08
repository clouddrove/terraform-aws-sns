provider "aws" {
  region = "eu-west-1"
}

module "sns" {
  source = "./../../../"

  name        = "basic-sns"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "application", "name"]

  platform    = "APNS"
  key         = "../../certificates/private_key.pem"
  certificate = "../../certificates/cert.pem"
}
