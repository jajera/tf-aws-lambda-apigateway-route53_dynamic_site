resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${local.name}"
  retention_in_days = 1

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_cloudwatch_log_group" "apigateway" {
  name              = "/aws/apigateway/${local.name}"
  retention_in_days = 1

  lifecycle {
    prevent_destroy = false
  }
}
