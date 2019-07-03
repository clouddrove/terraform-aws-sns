provider "aws" {
  region  = "eu-west-1"
}

module "sns" {
  source = "../../"
  name        = "clouddrove"
  platform    = "APNS"
  key         = "file("/home/clouddrove/private.key")"
  certificate = "file("/home/clouddrove/certificate.crt")"
}


