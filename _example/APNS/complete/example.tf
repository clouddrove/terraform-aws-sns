provider "aws" {
  region = "eu-west-1"
}

module "sqs" {
  source = "git::https://github.com/clouddrove/terraform-aws-sqs.git"

  name        = "sqs"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "name", "application"]

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
    actions   = ["sqs:SendMessage"]
    resources = ["arn:aws:sqs:eu-west-1:866067750630:test-sqs-clouddrove"]
  }
}

module "sns" {
  source = "git::https://github.com/clouddrove/terraform-aws-sns.git"

  name        = "sns"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "name", "application"]

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
        866067750630,
      ]
    }
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    resources = [
      "arn:aws:sns:eu-west-1:866067750630:app/APNS/test-sns-clouddrove",
    ]
    sid = "__default_statement_ID"
  }
}
