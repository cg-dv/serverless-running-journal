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
  name               = "lambda-execution-role-CRUD-query-scan"
  assume_role_policy = data.aws_iam_policy_document.lambda-assume-role-policy.json

  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]

  inline_policy {
    name = "dynamodb-CRUD-query-scan"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "dynamodb:DeleteItem",
            "dynamodb:GetItem",
            "dynamodb:PutItem",
            "dynamodb:Query",
            "dynamodb:Scan",
            "dynamodb:UpdateItem"
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

data "aws_s3_bucket_object" "CRUDList-function" {
  bucket = data.aws_s3_bucket.lambda-code-bucket.id
  key    = "CRUDList.js.zip"
}

resource "aws_lambda_function" "CRUD-list" {
  function_name     = "CRUD-List"
  role              = aws_iam_role.lambda-execution-role-CRUD-query-scan.arn
  handler           = "CRUDList.handler"
  s3_bucket         = data.aws_s3_bucket.lambda-code-bucket.id
  s3_key            = data.aws_s3_bucket_object.CRUDList-function.key
  s3_object_version = null

  runtime = "nodejs12.x"
}

output "writeItem-Lambda-execution-role" {
  value = aws_iam_role.lambda-execution-role-CRUD-query-scan.arn
}
