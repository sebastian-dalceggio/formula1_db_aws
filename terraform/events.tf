resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.data.bucket
  topic {
    topic_arn = aws_sns_topic.new_data_topic.arn
    events    = ["s3:ObjectCreated:*"]
  }
}

resource "aws_sns_topic" "new_data_topic" {
  name = "new_data"
}

resource "aws_sns_topic_policy" "new_data_topic_policy" {
  arn    = aws_sns_topic.new_data_topic.arn
  policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": { "Service": "s3.amazonaws.com" },
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:us-east-1:003745103673:new_data",
        "Condition": {
            "ArnLike": {
                "aws:SourceArn":"${aws_s3_bucket.data.arn}"}
        }
    }]
}
POLICY
}

resource "aws_sns_topic_subscription" "new_data_topic_new_data_queue" {
  topic_arn = aws_sns_topic.new_data_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.new_data_queue.arn
}

resource "aws_sqs_queue" "new_data_queue" {
  name                       = "new_data_queue"
  visibility_timeout_seconds = 350
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dead_letter_new_data_queue.arn
    maxReceiveCount     = 1
  })
}

resource "aws_sqs_queue_policy" "new_data_queue_policy" {
  queue_url = aws_sqs_queue.new_data_queue.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.new_data_queue.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.new_data_topic.arn}"
        }
      }
    }
  ]
}
POLICY
}



resource "aws_sqs_queue" "dead_letter_new_data_queue" {
  name                       = "dead_letter_new_data_queue"
  visibility_timeout_seconds = 350
}

resource "aws_sqs_queue_policy" "dead_letter_new_data_queue_policy" {
  queue_url = aws_sqs_queue.dead_letter_new_data_queue.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.dead_letter_new_data_queue.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sqs_queue.new_data_queue.arn}"
        }
      }
    }
  ]
}
POLICY
}