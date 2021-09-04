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

  attribute {
    name = "Date"
    type = "S"
  }

  attribute {
    name = "Distance"
    type = "N"
  }

  attribute {
    name = "Location"
    type = "S"
  }

  attribute {
    name = "Notes"
    type = "S"
  }

  tags = {
    Name = "run-table"
  }
}
