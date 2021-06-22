provider "aws" {
  region = "eu-west-1"
}

module "sns" {
  source = "./../../../"

  name = "text"
  environment = "test"
  label_order = ["name", "environment"]

  enabled               = true
  enable_sms_preference = true
  monthly_spend_limit   = "1"

  delivery_status_success_sampling_rate = "50"
  default_sender_id                     = "test"
  default_sms_type                      = "Transactional"

}