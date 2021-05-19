# Create an ACM certificate for use in the API Gateway.
# (see ../README.md#Namespace-by-branch)

resource "aws_acm_certificate" "hello" {
  domain_name = "${var.branch}.${var.domain}"
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

# Bind the cert to our FQDN
resource "aws_acm_certificate_validation" "hello" {
  certificate_arn         = aws_acm_certificate.hello.arn
  validation_record_fqdns = [for record in aws_route53_record.hello_validation : record.fqdn]
}

## Look up the Zone ID so we know where to create the record
data "aws_route53_zone" "hello" {
  name = var.domain
  private_zone = false
}

# Create validation records to prove ownership
resource "aws_route53_record" "hello_validation" {
  for_each = {
    for dvo in aws_acm_certificate.hello.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.hello.zone_id
}

# Finally bind the FQDN to the API Gateway
resource "aws_api_gateway_domain_name" "hello" {
  domain_name = "${var.branch}.${var.domain}"
  regional_certificate_arn = aws_acm_certificate_validation.hello.certificate_arn
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# And create the ALIAS record
## This is a special type of A record which generates via AWS API
## calls (viz. endpoint health checks)
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
