provider "aws" {
  region = "eu-west-1"
}

locals {
  name        = "basic-sns"
  environment = "test"
}

##-----------------------------------------------------------------------------
## SNS module call.
##-----------------------------------------------------------------------------
module "sns" {
  source = "./../../../"

  name        = local.name
  environment = local.environment
  enable_sns  = true
  platform    = "APNS"
  key         = "../../certificates/private_key.pem"
  certificate = "../../certificates/cert.pem"
}
