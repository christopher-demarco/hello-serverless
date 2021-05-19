# Declare the AWS provider
provider "aws" {
  region = "us-west-2"
  profile = "cmd"
}

# Store state in S3
terraform {
  backend "s3" {
    bucket = "cmd-hello-serverless"
    key = "terraform"
    region = "us-west-2"
  }
}
