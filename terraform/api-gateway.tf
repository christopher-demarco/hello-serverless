resource "aws_api_gateway_rest_api" "hello_lambda" {
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title = "Hello, Nuvalence!"
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
  name = "hello_nuvalence"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
