resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.cloudwatch_logs_retention_in_days

  tags = module.this.tags
}

resource "aws_lambda_function" "this" {
  function_name = "${module.this.id}-${var.function_name}"
  role          = aws_iam_role.this.arn
  runtime       = var.runtime
  timeout       = var.timeout
  memory_size   = var.memory_size
  handler       = var.handler

  s3_bucket = var.s3_bucket
  s3_key    = var.s3_key

  dynamic "environment" {
    for_each = length(var.environment_variables) > 0 ? [var.environment_variables] : []
    content {
      variables = var.environment_variables
    }
  }

  tags = module.this.tags

  depends_on = [
    aws_cloudwatch_log_group.this
  ]

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }
}

data "aws_iam_policy_document" "assume_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "logging_policy_document" {
  statement {
    actions = [
      "logs:PutLogEvents"
    ]

    resources = [
      "${aws_cloudwatch_log_group.this.arn}:log-stream:*"
    ]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogStreams"
    ]

    resources = [
      
      "${aws_cloudwatch_log_group.this.arn}"
    ]
  }
}

resource "aws_iam_role" "this" {
  name = "${var.function_name}-execution-role"

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_document.json

  inline_policy {
    name   = "logging_policy"
    policy = data.aws_iam_policy_document.logging_policy_document.json
  }

  dynamic "inline_policy" {
    for_each = var.inline_policies
    content {
      name   = inline_policy.value["name"]
      policy = inline_policy.value["policy"]
    }
  }

  tags = module.this.tags
}
