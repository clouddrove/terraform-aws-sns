provider "aws" {
  region = "eu-west-1"
}

module "sns" {
  source            = "git::https://github.com/clouddrove/terraform-aws-sns.git"
  
  name              = "clouddrove"
  platform          = "APNS"
  key               = file("./../../../certificates/private_key.pem")
  certificate       = file("./../../../certificates/cert.pem")
  topic_name        = "sns_topic"
  delivery_policy   = file("./../_json/delivery_policy.json")
  policy            = data.aws_iam_policy_document.sns-topic-policy.json
  endpoint          = "arn:aws:sqs:eu-west-1:866067750630:dev-sqs-clouddrove"
  update_preference = true
  create_topic      = true
  protocol          = "sqs"
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
      "arn:aws:sns:eu-west-1:866067750630:sns_topic",
    ]
    sid = "__default_statement_ID"
  }
}
