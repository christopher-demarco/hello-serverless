# Create an API Gateway to pass traffic to the Lambda

## Specify the API
resource "aws_api_gateway_rest_api" "hello_serverless" {
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title = "Hello, serverless!"
      version = "0.2"
    }
    paths = {
      "/" = {
	get = {
	  x-amazon-apigateway-integration = {
	    httpMethod = "GET"
	    payloadFormatVersion = "1.0"
	    type = "HTTP_PROXY"
	    uri = "https://ip-ranges.amazonaws.com/ip-ranges.json"
	  }
	}
      }
    }
  })
  name = "hello_serverless"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}


# ## Deploy the API
# resource "aws_api_gateway_deployment" "hello_serverless" {
#   rest_api_id = aws_api_gateway_rest_api.hello_serverless.id
#   triggers = {
#     redeployment = sha1(jsonencode(aws_api_gateway_rest_api.hello_serverless.body))
#   }
#   lifecycle {
#     create_before_destroy = true
#   }
# }
