resource "aws_lambda_function" "colors" {
  function_name    = "${local.name}-colors"
  filename         = "${path.module}/external/colors.zip"
  handler          = "index.handler"
  role             = aws_iam_role.lambda.arn
  runtime          = "nodejs20.x"
  source_code_hash = base64sha256(file("${path.module}/external/colors.mjs"))
  timeout          = 5

  depends_on = [
    aws_cloudwatch_log_group.lambda
  ]
}

resource "aws_lambda_permission" "colors_get" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.colors.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_apigatewayv2_api.example.id}/*/*/colors"
}

resource "aws_lambda_permission" "colors_get_by_id" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.colors.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_apigatewayv2_api.example.id}/*/*/colors/{id}"
}


resource "aws_lambda_permission" "colors_post" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.colors.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_apigatewayv2_api.example.id}/*/*/colors"
}
