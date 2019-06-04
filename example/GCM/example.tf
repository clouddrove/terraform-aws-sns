provider "aws" {
  region  = "eu-west-1"
}

module "sns" {
  source = "../../"
  name        = "clouddrove"
  platform    = "GCM"
  key         = "AAAA8TYQCtc:APA91bGe_q6xfkWyd6x4ie2UGqj4icP_6Kyz3OT2Ms1cbJZDOq3AkCAt5taasdsadasNpNE0g3oUQBdindsdsa1g7891cdrVAxbOmzL3XRd0ktgkFne2OwI7pC5an877XcBNQiHPMHT7dN7TykI2o6O2K"
}


