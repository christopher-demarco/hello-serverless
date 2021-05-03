resource "aws_iam_role" "iam_for_lambda" {
  name = "nuvalence-lambda-role"
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

resource "aws_lambda_function" "hello_lambda" {
  filename = "../hello.app/hello.zip"
  function_name = "hello-nuvalence"
  handler = "hello.main"
  role = aws_iam_role.iam_for_lambda.arn
  source_code_hash = filebase64sha256("../hello.app/hello.zip")
  runtime = "python3.6"
}
