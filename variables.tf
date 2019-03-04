variable "region" {
  default = "us-west-2"
}

variable "environment_tag" {
  default = "Lambda Example"
}

variable "lambda_role_name" {
  default = "ExampleLambdaRole"
}

variable "lambda_s3_policy_name" {
  default = "ExampleLambdaS3Policy"
}

variable "lambda_role_policy" {
  default = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
EOF
}

variable "lambda_role_s3_policy" {
  default = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

variable "function_name" {
  default = "minimal_lambda_function"
}

variable "handler" {
  default = "lambda.handler"
}

variable "runtime" {
  default = "python3.6"
}

variable "api_stage_name" {
  default = "test"
}

variable "base_zone" {
  default = "example.com"
}

variable "example_host" {
  default = "test-lambda"
}
