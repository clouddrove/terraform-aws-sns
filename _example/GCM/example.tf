provider "aws" {
  region  = "eu-west-1"
}

module "sns" {
  source = "git::https://github.com/clouddrove/terraform-aws-sns.git"
  name        = "clouddrove"
  platform    = "GCM"
  key         = "AAAAKHQaqe1w:APA91bEgwftAYq6N2YV8TeU2k4bRj0k1q2I7Q47ZvFPLQm-ESbD2Fhjj3U9wNNuZ2aC-QZVdgDrN5C6E3Ec08AWhMgbs4b72gNvqcXh1JBoR6yLwretghyjutTR4yRmT0vWdhz4_PW1AwDC0aVoH"
}


