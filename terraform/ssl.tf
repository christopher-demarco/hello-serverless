# Create a custom domain name tied to a pre-existing ACM certificate
# for use by the API Gateway. (see ../README.md#Namespace-by-branch
# and ../README.md#Prerequisites)


## Look up the Zone ID so we know where to create the record
data "aws_route53_zone" "hello" {
  name = var.domain
  private_zone = false
}
## Look up the ACM certificate
data "aws_acm_certificate" "hello" {
  domain = "*.${var.domain}"
  statuses = ["ISSUED"]
}


## Bind the FQDN to the API Gateway
resource "aws_api_gateway_domain_name" "hello" {
  domain_name = "${var.environment}.${var.domain}"
  regional_certificate_arn = data.aws_acm_certificate.hello.arn
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
resource "aws_api_gateway_base_path_mapping" "hello" {
  api_id = aws_api_gateway_rest_api.hello.id
  stage_name = aws_api_gateway_deployment.hello.stage_name
  domain_name = "${var.environment}.${var.domain}"
}


## Create the ALIAS record in Route53, pointing to the API Gateway
### This proprietary AWS record type is a variant A record which
### generates results via AWS API calls (viz. endpoint health checks).
resource "aws_route53_record" "hello" {
  name = aws_api_gateway_domain_name.hello.domain_name
  type = "A"
  zone_id = data.aws_route53_zone.hello.zone_id
  alias {
    evaluate_target_health = true
    name = aws_api_gateway_domain_name.hello.regional_domain_name
    zone_id = aws_api_gateway_domain_name.hello.regional_zone_id
  }
}


## Output the custom URL
output "custom-url" {
  value = "https://${var.environment}.${var.domain}"
}
