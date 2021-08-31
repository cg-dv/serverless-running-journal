data "aws_iam_policy_document" "lambda-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda-execution-role-dynamodb-read" {
  name               = "lambda-execution-role-dynamodb-read"
  assume_role_policy = data.aws_iam_policy_document.lambda-assume-role-policy.json

  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]

  inline_policy {
    name = "dynamodb-read"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = "dynamodb:GetItem",
          Effect   = "Allow",
          Resource = aws_dynamodb_table.serverless-app-table.arn
        }
      ]
    })
  }
}

resource "aws_iam_role" "lambda-execution-role-dynamodb-write" {
  name               = "lambda-execution-role-dynamodb-write"
  assume_role_policy = data.aws_iam_policy_document.lambda-assume-role-policy.json

  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]

  inline_policy {
    name = "dynamodb-write"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = "dynamodb:PutItem",
          Effect   = "Allow",
          Resource = aws_dynamodb_table.serverless-app-table.arn
        }
      ]
    })
  }
}

resource "aws_iam_role" "lambda-execution-role-dynamodb-list" {
  name               = "lambda-execution-role-dynamodb-list"
  assume_role_policy = data.aws_iam_policy_document.lambda-assume-role-policy.json

  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]

  inline_policy {
    name = "dynamodb-list"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = "dynamodb:ListItems",
          Effect   = "Allow",
          Resource = aws_dynamodb_table.serverless-app-table.arn
        }
      ]
    })
  }
}

data "aws_s3_bucket" "lambda-code-bucket" {
  bucket = "lambda-serverless-example-app-code"
}

data "aws_s3_bucket_object" "readItem-function" {
  bucket = data.aws_s3_bucket.lambda-code-bucket.id
  key    = "readItem.js.zip"
}

resource "aws_lambda_function" "readItem" {
  function_name     = "readItem"
  role              = aws_iam_role.lambda-execution-role-dynamodb.arn
  handler           = "submitRun.handler"
  s3_bucket         = data.aws_s3_bucket.lambda-code-bucket.id
  s3_key            = data.aws_s3_bucket_object.read-item-function.key
  s3_object_version = null
  #source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "nodejs12.x"
}

resource "aws_lambda_function" "writeItem" {
  function_name     = "writeItem"
  role              = aws_iam_role.lambda-execution-role-dynamodb.arn
  handler           = "submitRun.handler"
  s3_bucket         = data.aws_s3_bucket.lambda-code-bucket.id
  s3_key            = data.aws_s3_bucket_object.write-item-function.key
  s3_object_version = null
  #source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "nodejs12.x"
}

resource "aws_lambda_function" "listItems" {
  function_name     = "listItems"
  role              = aws_iam_role.lambda-execution-role-dynamodb.arn
  handler           = "submitRun.handler"
  s3_bucket         = data.aws_s3_bucket.lambda-code-bucket.id
  s3_key            = data.aws_s3_bucket_object.list-items-function.key
  s3_object_version = null
  #source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "nodejs12.x"
}
