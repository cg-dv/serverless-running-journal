data "aws_iam_policy_document" "lambda-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda-execution-role-CRUD-query-scan" {
  name               = "lambda-execution-role-dynamodb-read"
  assume_role_policy = data.aws_iam_policy_document.lambda-assume-role-policy.json

  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]

  inline_policy {
    name = "dynamodb-CRUD-query-scan"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = [
            "dynamodb:DeleteItem",
            "dynamodb:GetItem",
            "dynamodb:PutItem",
            "dynamodb:Query",
            "dynamodb:Scan",
            "dynamodb:Update"
          ],
          Effect   = "Allow",
          Resource = aws_dynamodb_table.serverless-app-table.arn
        },
        {
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          Effect   = "Allow",
          Resource = "*" 
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

data "aws_s3_bucket_object" "writeItem-function" {
  bucket = data.aws_s3_bucket.lambda-code-bucket.id
  key    = "writeItem.js.zip"
}

data "aws_s3_bucket_object" "updateItem-function" {
  bucket = data.aws_s3_bucket.lambda-code-bucket.id
  key    = "updateItem.js.zip"
}

data "aws_s3_bucket_object" "deleteItem-function" {
  bucket = data.aws_s3_bucket.lambda-code-bucket.id
  key    = "deleteItem.js.zip"
}

#data "aws_s3_bucket_object" "listItems-function" {
#bucket = data.aws_s3_bucket.lambda-code-bucket.id
#key    = "listItems.js.zip"
#}

resource "aws_lambda_function" "readItem" {
  function_name     = "readItem"
  role              = aws_iam_role.lambda-execution-role-CRUD-query-scan.arn
  handler           = "readItem.handler"
  s3_bucket         = data.aws_s3_bucket.lambda-code-bucket.id
  s3_key            = data.aws_s3_bucket_object.readItem-function.key
  s3_object_version = null

  runtime = "nodejs12.x"
}

resource "aws_lambda_function" "writeItem" {
  function_name     = "writeItem"
  role              = aws_iam_role.lambda-execution-role-dynamodb-write.arn
  handler           = "writeItem.handler"
  s3_bucket         = data.aws_s3_bucket.lambda-code-bucket.id
  s3_key            = data.aws_s3_bucket_object.writeItem-function.key
  s3_object_version = null

  runtime = "nodejs12.x"
}

resource "aws_lambda_function" "updateItem" {
  function_name     = "updateItem"
  role              = aws_iam_role.lambda-execution-role-dynamodb-update.arn
  handler           = "updateItem.handler"
  s3_bucket         = data.aws_s3_bucket.lambda-code-bucket.id
  s3_key            = data.aws_s3_bucket_object.updateItem-function.key
  s3_object_version = null

  runtime = "nodejs12.x"
}

resource "aws_lambda_function" "deleteItem" {
  function_name     = "deleteItem"
  role              = aws_iam_role.lambda-execution-role-dynamodb-delete.arn
  handler           = "deleteItem.handler"
  s3_bucket         = data.aws_s3_bucket.lambda-code-bucket.id
  s3_key            = data.aws_s3_bucket_object.deleteItem-function.key
  s3_object_version = null

  runtime = "nodejs12.x"
}

#resource "aws_lambda_function" "listItems" {
#function_name     = "listItems"
#role              = aws_iam_role.lambda-execution-role-dynamodb-list.arn
#handler           = "listItems.handler"
#s3_bucket         = data.aws_s3_bucket.lambda-code-bucket.id
#s3_key            = data.aws_s3_bucket_object.listItems-function.key
#s3_object_version = null

#runtime = "nodejs12.x"
#}

output "writeItem-Lambda-execution-role" {
  value = aws_iam_role.lambda-execution-role-dynamodb-write.arn
}
