provider "aws" {
  region = "eu-west-1"
}

module "sns" {
  source = "./../../"

  name        = "sqs"
  environment = "test"
  label_order = ["name", "environment"]
  enable_sns  = true
  platform    = "GCM"
  gcm_key     = "AAAA8TYQCtc:APesgdrthyujioyhtgfds4icP_6Kyz3OT2Ms1cbJZDOq3AkCAt5tNpNE0g3oUQBdind1g7891cdrVAxbOmzL3XRd0ktgkFne2OwI7pC5an877XcBNQiHPMHT7dN7TykI2o6O2K"
}
