data "aws_caller_identity" "current" {}

resource "aws_api_gateway_rest_api" "run-log-api" {
  name = "run-log-api"
  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_lambda_permission" "allow-api-gateway-read" {
  statement_id  = "AllowAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.readItem.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:us-east-1:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.run-log-api.id}/*/*/*" 

  depends_on = [
    aws_api_gateway_rest_api.run-log-api,
    aws_lambda_function.readItem
  ]
}

resource "aws_lambda_permission" "allow-api-gateway-write" {
  statement_id  = "AllowAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.writeItem.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:us-east-1:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.run-log-api.id}/*/*/*" 

  depends_on = [
    aws_api_gateway_rest_api.run-log-api,
    aws_lambda_function.writeItem
  ]
}

resource "aws_lambda_permission" "allow-api-gateway-update" {
  statement_id  = "AllowAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.updateItem.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:us-east-1:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.run-log-api.id}/*/*/*" 

  depends_on = [
    aws_api_gateway_rest_api.run-log-api,
    aws_lambda_function.updateItem
  ]
}

#resource "aws_api_gateway_authorizer" "run-log-auth" {
#name          = "run-log-auth"
#type          = "COGNITO_USER_POOLS"
#rest_api_id   = aws_api_gateway_rest_api.run-log-api.id
#provider_arns = ["arn:aws:cognito-idp:us-east-1:414402433373:userpool/us-east-1_M1mWlsyXz"]
#}

resource "aws_api_gateway_resource" "read" {
  rest_api_id = aws_api_gateway_rest_api.run-log-api.id
  parent_id   = aws_api_gateway_rest_api.run-log-api.root_resource_id
  path_part   = "readItem"
}

resource "aws_api_gateway_resource" "write" {
  rest_api_id = aws_api_gateway_rest_api.run-log-api.id
  parent_id   = aws_api_gateway_rest_api.run-log-api.root_resource_id
  path_part   = "writeItem"
}

resource "aws_api_gateway_resource" "update" {
  rest_api_id = aws_api_gateway_rest_api.run-log-api.id
  parent_id   = aws_api_gateway_rest_api.run-log-api.root_resource_id
  path_part   = "updateItem"
}

#resource "aws_api_gateway_resource" "list" {
  #rest_api_id = aws_api_gateway_rest_api.run-log-api.id
  #parent_id   = aws_api_gateway_rest_api.run-log-api.root_resource_id
  #path_part   = "listItems"
#}

resource "aws_api_gateway_method" "serverless-get-method" {
  rest_api_id   = aws_api_gateway_rest_api.run-log-api.id
  resource_id   = aws_api_gateway_resource.read.id
  http_method   = "GET"
  authorization = "NONE"
  #authorizer_id = aws_api_gateway_authorizer.run-log-auth.id
}

resource "aws_api_gateway_method" "serverless-post-method" {
  rest_api_id   = aws_api_gateway_rest_api.run-log-api.id
  resource_id   = aws_api_gateway_resource.write.id
  http_method   = "POST"
  authorization = "NONE"
  #authorizer_id = aws_api_gateway_authorizer.run-log-auth.id
}

resource "aws_api_gateway_method" "serverless-post-method-update" {
  rest_api_id   = aws_api_gateway_rest_api.run-log-api.id
  resource_id   = aws_api_gateway_resource.update.id
  http_method   = "POST"
  authorization = "NONE"
  #authorizer_id = aws_api_gateway_authorizer.run-log-auth.id
}

#resource "aws_api_gateway_method" "serverless-get-method-list" {
#rest_api_id   = aws_api_gateway_rest_api.run-log-api.id
#resource_id   = aws_api_gateway_resource.list.id
#http_method   = "GET"
#authorization = "NONE"
#authorizer_id = aws_api_gateway_authorizer.run-log-auth.id
#}

resource "aws_api_gateway_integration" "read-integration" {
  http_method             = aws_api_gateway_method.serverless-get-method.http_method
  integration_http_method = aws_api_gateway_method.serverless-get-method.http_method
  uri                     = aws_lambda_function.readItem.invoke_arn
  resource_id             = aws_api_gateway_resource.read.id
  rest_api_id             = aws_api_gateway_rest_api.run-log-api.id
  type                    = "AWS_PROXY"
}

resource "aws_api_gateway_integration" "write-integration" {
  http_method             = aws_api_gateway_method.serverless-post-method.http_method
  integration_http_method = aws_api_gateway_method.serverless-post-method.http_method
  uri                     = aws_lambda_function.writeItem.invoke_arn
  resource_id             = aws_api_gateway_resource.write.id
  rest_api_id             = aws_api_gateway_rest_api.run-log-api.id
  type                    = "AWS_PROXY"
}

resource "aws_api_gateway_integration" "update-integration" {
  http_method             = aws_api_gateway_method.serverless-post-method-update.http_method
  integration_http_method = aws_api_gateway_method.serverless-post-method-update.http_method
  uri                     = aws_lambda_function.updateItem.invoke_arn
  resource_id             = aws_api_gateway_resource.update.id
  rest_api_id             = aws_api_gateway_rest_api.run-log-api.id
  type                    = "AWS_PROXY"
}

#resource "aws_api_gateway_integration" "list-integration" {
#http_method             = aws_api_gateway_method.serverless-get-method-list.http_method
#integration_http_method = aws_api_gateway_method.serverless-get-method-list.http_method
#uri                     = aws_lambda_function.listItems.invoke_arn
#resource_id             = aws_api_gateway_resource.list.id
#rest_api_id             = aws_api_gateway_rest_api.run-log-api.id
#type                    = "AWS_PROXY"
#}

resource "aws_api_gateway_deployment" "example" {
  rest_api_id = aws_api_gateway_rest_api.run-log-api.id

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_lambda_function.writeItem,
    aws_api_gateway_rest_api.run-log-api,
    #aws_api_gateway_authorizer.run-log-auth,
    aws_api_gateway_resource.write,
    aws_api_gateway_method.serverless-post-method,
    aws_api_gateway_integration.write-integration
  ]
}

output "api-gateway-invoke-url" {
  value = aws_api_gateway_deployment.example.invoke_url
}
