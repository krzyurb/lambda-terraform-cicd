provider "aws" {
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  region                      = "eu-central-1"
  s3_force_path_style         = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  endpoints {
    apigateway = "http://localhost:4566"
    lambda     = "http://localhost:4566"
    iam        = "http://localhost:4566"
    s3         = "http://localhost:4566"
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

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

data "archive_file" "lambda_code" {
  type        = "zip"
  output_path = "${path.module}/dist/lambda_archive.zip"
  source_dir  = "../${path.module}/lambda"
}

resource "aws_lambda_function" "hello_lambda" {
  filename      = "${data.archive_file.lambda_code.output_path}"
  function_name = "lambda_function_name"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "lambda.handler"
  runtime       = "nodejs12.x"
  environment {
    variables = {
      foo = "bar"
    }
  }
}
