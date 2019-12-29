provider "aws" {
  region = "eu-west-1"
}

data "aws_caller_identity" "current" {}


module "sqs" {
  source = "git::https://github.com/clouddrove/terraform-aws-sqs.git?ref=tags/0.12.2"

  name        = "sqs"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "application", "name"]

  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  policy                    = data.aws_iam_policy_document.document.json
}

data "aws_iam_policy_document" "document" {
  version = "2012-10-17"
  statement {
    sid    = "First"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = ["sqs:SendMessage"]
    resources = [
      format("arn:aws:sqs:eu-west-1:%s:test-clouddrove-sqs", data.aws_caller_identity.current.account_id)
    ]
  }
}

module "sns" {
  source = "./../../../"

  name        = "sns"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "application", "name"]

  platform              = "APNS"
  enable_sms_preference = true
  enable_topic          = true
  endpoint              = module.sqs.arn
  protocol              = "sqs"

  key             = "../../certificates/private_key.pem"
  certificate     = "../../certificates/cert.pem"
  delivery_policy = "../../_json/delivery_policy.json"
  policy          = data.aws_iam_policy_document.sns-topic-policy.json
}

data "aws_iam_policy_document" "sns-topic-policy" {
  policy_id = "__default_policy_ID"
  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        data.aws_caller_identity.current.account_id,
      ]
    }
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    resources = [
      format("arn:aws:sns:eu-west-1:%s:app/APNS/test-clouddrove-sns", data.aws_caller_identity.current.account_id)
    ]
    sid = "__default_statement_ID"
  }
}
