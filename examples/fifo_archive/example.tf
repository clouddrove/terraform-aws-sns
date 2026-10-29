resource "aws_sqs_queue" "orders" {
  name                        = "orders-prod.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
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
      replay_policy = jsonencode({
        PointType     = "Timestamp"
        StartingPoint = timeadd(timestamp(), "-1h")
      })
    }
  }
}
