provider "aws" {
  region  = "eu-west-1"
}

module "sns" {
  source = "../../"
  name        = "clouddrove"
  platform    = "APNS"
  key         = file("./../../../certificates/private_key.pem")
  certificate = file("./../../../certificates/cert.pem")
}
