provider "aws" {
  region = "eu-west-1"
}

module "sns" {
  source = "git::https://github.com/clouddrove/terraform-aws-sns.git"

  name        = "basic-sns"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "name", "application"]

  platform    = "APNS"
  key         = "../../certificates/private_key.pem"
  certificate = "../../certificates/cert.pem"
}