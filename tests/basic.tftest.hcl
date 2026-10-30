mock_provider "aws" {}

variables {
}

run "validate_module" {
  command = plan
}

run "fifo_archive_and_payload_filtering" {
  command = plan

  variables {
    name                                  = "events-test.fifo"
    environment                           = "prod"
    enable_topic                          = true
    create_topic_policy                   = false
    fifo_topic                            = true
    fifo_throughput_scope                 = "MessageGroup"
    content_based_deduplication           = true
    firehose_success_feedback_role_arn    = "arn:aws:iam::123456789012:role/sns-feedback"
    firehose_success_feedback_sample_rate = 25
    firehose_failure_feedback_role_arn    = "arn:aws:iam::123456789012:role/sns-feedback"
    archive_policy = jsonencode({
      MessageRetentionPeriod = 30
    })

    subscribers = {
      queue = {
        protocol            = "sqs"
        endpoint            = "arn:aws:sqs:eu-west-1:123456789012:events-test.fifo"
        filter_policy       = jsonencode({ event_type = ["created"] })
        filter_policy_scope = "MessageBody"
        replay_policy = jsonencode({
          PointType     = "Timestamp"
          StartingPoint = "2026-10-29T00:00:00Z"
        })
      }
    }
  }

  assert {
    condition     = aws_sns_topic.default[0].name == "events-test-prod.fifo"
    error_message = "FIFO topic names must end with .fifo after the environment suffix."
  }

  assert {
    condition     = aws_sns_topic.default[0].fifo_throughput_scope == "MessageGroup"
    error_message = "FIFO throughput scope was not passed to the topic."
  }

  assert {
    condition     = aws_sns_topic.default[0].firehose_success_feedback_sample_rate == 25
    error_message = "Firehose delivery-status logging was not passed to the topic."
  }

  assert {
    condition     = aws_sns_topic_subscription.this["queue"].filter_policy_scope == "MessageBody"
    error_message = "Payload-based subscription filtering was not configured."
  }
}

run "subscribe_to_existing_topic" {
  command = plan

  variables {
    topic_arn = "arn:aws:sns:eu-west-1:123456789012:existing-topic"
    subscribers = {
      lambda = {
        protocol = "lambda"
        endpoint = "arn:aws:lambda:eu-west-1:123456789012:function:consumer"
      }
    }
  }

  assert {
    condition     = aws_sns_topic_subscription.this["lambda"].topic_arn == var.topic_arn
    error_message = "The subscription was not attached to the supplied existing topic ARN."
  }
}

run "apns_token_authentication" {
  command = plan

  variables {
    name                     = "mobile"
    enable_sns               = true
    platform                 = "APNS"
    platform_credential      = "test-signing-key"
    platform_principal       = "KEYID12345"
    apple_platform_team_id   = "TEAMID1234"
    apple_platform_bundle_id = "com.example.mobile"
  }

  assert {
    condition     = aws_sns_platform_application.default[0].apple_platform_bundle_id == "com.example.mobile"
    error_message = "APNS token authentication fields were not passed to the platform application."
  }
}

run "reject_non_fifo_attributes" {
  command = plan

  variables {
    enable_topic          = true
    create_topic_policy   = false
    fifo_throughput_scope = "MessageGroup"
  }

  expect_failures = [aws_sns_topic.default]
}

run "reject_policy_with_managed_policy" {
  command = plan

  variables {
    enable_topic        = true
    policy              = "{}"
    create_topic_policy = true
  }

  expect_failures = [aws_sns_topic.default]
}

run "reject_topic_arn_with_created_topic" {
  command = plan

  variables {
    enable_topic = true
    topic_arn    = "arn:aws:sns:eu-west-1:123456789012:existing-topic"
  }

  expect_failures = [var.topic_arn]
}

run "reject_firehose_without_role" {
  command = plan

  variables {
    subscribers = {
      delivery = {
        protocol              = "firehose"
        endpoint              = "arn:aws:firehose:eu-west-1:123456789012:deliverystream/events"
        subscription_role_arn = ""
      }
    }
  }

  expect_failures = [var.subscribers]
}

run "reject_unsupported_subscriber_protocol" {
  command = plan

  variables {
    subscribers = {
      consumer = {
        protocol = "ftp"
        endpoint = "example"
      }
    }
  }

  expect_failures = [var.subscribers]
}

run "reject_invalid_archive_retention" {
  command = plan

  variables {
    enable_topic        = true
    fifo_topic          = true
    create_topic_policy = false
    archive_policy      = jsonencode({ MessageRetentionPeriod = 366 })
  }

  expect_failures = [var.archive_policy]
}

run "reject_unpaired_apns_token_fields" {
  command = plan

  variables {
    enable_sns             = true
    platform               = "APNS"
    platform_credential    = "test-signing-key"
    apple_platform_team_id = "TEAMID1234"
  }

  expect_failures = [aws_sns_platform_application.default]
}
