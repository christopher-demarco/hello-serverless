# Create CloudWatch log groups

resource "aws_cloudwatch_log_group" "hello" {
  name = "/aws/lambda/hello-${var.environment}"
  retention_in_days = 7
}
