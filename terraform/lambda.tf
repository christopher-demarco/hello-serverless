# Create a Lambda function

resource "aws_lambda_function" "hello" {
  filename = "../hello.app/hello.zip"
  function_name = "hello-${var.environment}"
  handler = "hello.main"
  role = aws_iam_role.hello.arn
  source_code_hash = filebase64sha256("../hello.app/hello.zip")
  runtime = "python3.6"
  depends_on = [
    aws_iam_role_policy_attachment.hello-logs,
    aws_cloudwatch_log_group.hello
  ]
}


## Create the Role that the Lambda will assume. Initially without a
## Policy, the Lambda won't be able to do much except run pure Python.

resource "aws_iam_role" "hello" {
  name = "hello-${var.environment}-lambda"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

### Permit the Lambda to talk to CloudWatch for logging
resource "aws_iam_policy" "hello-logs" {
  name = "hello-${var.environment}-logs"
  path = "/"
  description = "IAM policy for logging from a lambda"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "hello-logs" {
  role = aws_iam_role.hello.name
  policy_arn = aws_iam_policy.hello-logs.arn
}
