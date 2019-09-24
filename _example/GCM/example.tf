provider "aws" {
  region = "eu-west-1"
}

module "sns" {
  source = "git::https://github.com/clouddrove/terraform-aws-sns.git?ref=tags/0.12.0"

  name        = "sqs"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "name", "application"]

  platform = "GCM"
  gcm_key  = "AAAA8TYQCtc:APesgdrthyujioyhtgfds4icP_6Kyz3OT2Ms1cbJZDOq3AkCAt5tNpNE0g3oUQBdind1g7891cdrVAxbOmzL3XRd0ktgkFne2OwI7pC5an877XcBNQiHPMHT7dN7TykI2o6O2K"
}