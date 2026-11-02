resource "aws_sqs_queue" "orders" {
  name                        = "orders-prod.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  sqs_managed_sse_enabled     = true
}

data "aws_iam_policy_document" "allow_sns" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.orders.arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [module.sns.topic-arn]
    }
  }
}

resource "aws_sqs_queue_policy" "allow_sns" {
  queue_url = aws_sqs_queue.orders.id
  policy    = data.aws_iam_policy_document.allow_sns.json
}

module "sns" {
  source = "./../../"

  name                        = "orders.fifo"
  environment                 = "prod"
  enable_topic                = true
  fifo_topic                  = true
  fifo_throughput_scope       = "MessageGroup"
  content_based_deduplication = true
  archive_policy              = jsonencode({ MessageRetentionPeriod = 30 })

  subscribers = {
    orders = {
      protocol = "sqs"
      endpoint = aws_sqs_queue.orders.arn
    }
  }
}
