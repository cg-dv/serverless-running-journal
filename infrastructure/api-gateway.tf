data "aws_caller_identity" "current" {}

resource "aws_api_gateway_rest_api" "run-log-api" {
  name = "run-log-api"
  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_lambda_permission" "allow-api-gateway-CRUD-query-scan" {
  statement_id  = "AllowAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.CRUD-list.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:us-east-1:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.run-log-api.id}/*/*/*"

  depends_on = [
    aws_api_gateway_rest_api.run-log-api,
    aws_lambda_function.CRUD-list
  ]
}

#resource "aws_api_gateway_authorizer" "run-log-auth" {
#name          = "run-log-auth"
#type          = "COGNITO_USER_POOLS"
#rest_api_id   = aws_api_gateway_rest_api.run-log-api.id
#provider_arns = ["arn:aws:cognito-idp:us-east-1:414402433373:userpool/us-east-1_M1mWlsyXz"]
#}

resource "aws_api_gateway_resource" "any" {
  rest_api_id = aws_api_gateway_rest_api.run-log-api.id
  parent_id   = aws_api_gateway_rest_api.run-log-api.root_resource_id
  path_part   = "CRUDList"
}

resource "aws_api_gateway_method" "serverless-post-method" {
  rest_api_id   = aws_api_gateway_rest_api.run-log-api.id
  resource_id   = aws_api_gateway_resource.any.id
  http_method   = "POST"
  authorization = "NONE"
  #authorizer_id = aws_api_gateway_authorizer.run-log-auth.id
}

resource "aws_api_gateway_integration" "CRUD-integration" {
  http_method             = aws_api_gateway_method.serverless-post-method.http_method
  integration_http_method = aws_api_gateway_method.serverless-post-method.http_method
  uri                     = aws_lambda_function.CRUD-list.invoke_arn
  resource_id             = aws_api_gateway_resource.any.id
  rest_api_id             = aws_api_gateway_rest_api.run-log-api.id
  type                    = "AWS"
}

resource "aws_api_gateway_method_response" "method-response" {
  rest_api_id = aws_api_gateway_rest_api.run-log-api.id
  resource_id = aws_api_gateway_resource.any.id
  http_method = aws_api_gateway_method.serverless-post-method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "integration-response" {
  rest_api_id = aws_api_gateway_rest_api.run-log-api.id
  resource_id = aws_api_gateway_resource.any.id
  http_method = aws_api_gateway_method.serverless-post-method.http_method
  status_code = "200" 
}

resource "aws_api_gateway_deployment" "example" {
  rest_api_id = aws_api_gateway_rest_api.run-log-api.id

  lifecycle {
    create_before_destroy = true
  }

 triggers = {
    
    redeployment = sha1(jsonencode([
        aws_lambda_function.CRUD-list.id,
        aws_api_gateway_rest_api.run-log-api.id,
        #aws_api_gateway_authorizer.run-log-auth.id,
        aws_api_gateway_resource.any.id,
        aws_api_gateway_method.serverless-post-method.id,
        aws_api_gateway_method_response.method-response.id,
        aws_api_gateway_integration.CRUD-integration.id
    ]))
  }
}

output "api-gateway-invoke-url" {
  value = aws_api_gateway_deployment.example.invoke_url
}
