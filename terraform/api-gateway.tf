# Create an API Gateway to pass traffic to the Lambda

## Create the bare object
resource "aws_api_gateway_rest_api" "hello" {
  name = "hello-${var.environment}"
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
resource "aws_api_gateway_method" "hello" {
  rest_api_id = aws_api_gateway_rest_api.hello.id
  resource_id = aws_api_gateway_rest_api.hello.root_resource_id
  http_method = "ANY"
  authorization = "NONE"
}
## Bind it to the Lambda
resource "aws_api_gateway_integration" "hello_root" {
  rest_api_id = aws_api_gateway_rest_api.hello.id
  resource_id = aws_api_gateway_method.hello.resource_id
  http_method = aws_api_gateway_method.hello.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.hello.invoke_arn
}


## Deploy the API Gateway so that it's active
resource "aws_api_gateway_deployment" "hello" {
  depends_on = [
    aws_api_gateway_integration.hello_root
  ]
  rest_api_id = aws_api_gateway_rest_api.hello.id
  stage_name = var.environment
}


## Output the API GW endpoint
output "api-gw-url" {
  value = aws_api_gateway_deployment.hello.invoke_url
}
