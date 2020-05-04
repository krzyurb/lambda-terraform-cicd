data "archive_file" "lambda_code" {
  type        = "zip"
  output_path = "${path.module}/dist/lambda_archive.zip"
  source_dir  = "../${path.module}/lambda"
}

resource "aws_lambda_function" "lambda_function" {
  filename      = data.archive_file.lambda_code.output_path
  function_name = "lambda_function"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda.handler"
  runtime       = "nodejs12.x"
  depends_on    = [aws_iam_role.iam_for_lambda]
  environment {
    variables = {
      foo = "bar"
    }
  }
}
