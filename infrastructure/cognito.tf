resource "aws_cognito_user_pool" "serverless-example-pool" {
  name = "serverless-pool"
}


resource "aws_cognito_user_pool_client" "client" {
  name = "pool-client"

  user_pool_id    = aws_cognito_user_pool.serverless-example-pool.id
  generate_secret = false
}

output "pool-id" {
  value = aws_cognito_user_pool.serverless-example-pool.id
}

output "pool-client-id" {
  value = aws_cognito_user_pool_client.client.id
}
