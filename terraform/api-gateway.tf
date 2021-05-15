# Create an API Gateway to pass traffic to the Lambda

## Create the bare object
resource "aws_api_gateway_rest_api" "hello" {
  name = "hello"
}


## Permit the Lambda to access it
resource "aws_lambda_permission" "hello" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.hello.function_name
   principal     = "apigateway.amazonaws.com"
   source_arn = "${aws_api_gateway_rest_api.hello.execution_arn}/*/*"
}


## Create the proxy
### Match any path
resource "aws_api_gateway_resource" "hello" {
  rest_api_id = aws_api_gateway_rest_api.hello.id
  parent_id = aws_api_gateway_rest_api.hello.root_resource_id
  path_part = "{proxy+}"
}
### And any method
resource "aws_api_gateway_method" "hello" {
  rest_api_id = aws_api_gateway_rest_api.hello.id
  resource_id = aws_api_gateway_resource.hello.id
  http_method = "ANY"
  authorization = "NONE"
}
resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id = aws_api_gateway_rest_api.hello.id
  resource_id = aws_api_gateway_rest_api.hello.root_resource_id
  http_method = "ANY"
  authorization = "NONE"
}


## Bind the API GW to the Lambda
resource "aws_api_gateway_integration" "hello" {
  rest_api_id = aws_api_gateway_rest_api.hello.id
  resource_id = aws_api_gateway_method.hello.resource_id
  http_method = aws_api_gateway_method.hello.http_method
  integration_http_method = "GET"
  type = "AWS_PROXY"
  uri = aws_lambda_function.hello.invoke_arn
}
resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = aws_api_gateway_rest_api.hello.id
  resource_id = aws_api_gateway_method.proxy_root.resource_id
  http_method = aws_api_gateway_method.proxy_root.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.hello.invoke_arn
}


## Finally deploy it
resource "aws_api_gateway_deployment" "hello" {
  depends_on = [
    aws_api_gateway_integration.hello,
    aws_api_gateway_integration.lambda_root
  ]
  rest_api_id = aws_api_gateway_rest_api.hello.id
  stage_name = var.branch
}


# Output the URL for accessing it
output "URL" { value = aws_api_gateway_deployment.hello.invoke_url }
