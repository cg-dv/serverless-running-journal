resource "aws_dynamodb_table" "serverless-app-table" {
  name           = "Runs"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "RunId"

  attribute {
    name = "RunId"
    type = "S"
  }

  tags = {
    Name = "run-table"
  }
}
