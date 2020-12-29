provider "aws" {
  region = "eu-west-1"
}

module "sns" {
  source = "./../../../"

  name        = "basic-sns"
  repository  = "https://registry.terraform.io/modules/clouddrove/sns/aws/0.14.0"
  environment = "test"
  label_order = ["name", "environment"]

  platform    = "APNS"
  key         = "../../certificates/private_key.pem"
  certificate = "../../certificates/cert.pem"
}
