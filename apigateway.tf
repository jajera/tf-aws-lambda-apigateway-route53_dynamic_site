resource "aws_apigatewayv2_api" "example" {
  name = local.name

  cors_configuration {
    allow_methods = ["GET", "POST"]
    allow_origins = ["*"]
  }

  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.example.id
  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.apigateway.arn
    format = jsonencode({
      requestId      = "$context.requestId",
      sourceIp       = "$context.identity.sourceIp",
      httpMethod     = "$context.httpMethod",
      status         = "$context.status",
      protocol       = "$context.protocol",
      responseLength = "$context.responseLength"
    })
  }
}

resource "aws_apigatewayv2_domain_name" "web" {
  domain_name = local.web_domain_name

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.web.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  depends_on = [
    aws_apigatewayv2_api.example,
    aws_acm_certificate_validation.web
  ]
}

resource "aws_apigatewayv2_integration" "colors_post" {
  api_id                 = aws_apigatewayv2_api.example.id
  connection_type        = "INTERNET"
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.colors.invoke_arn
  passthrough_behavior   = "WHEN_NO_MATCH"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "colors_post" {
  api_id    = aws_apigatewayv2_api.example.id
  route_key = "POST /colors"
  target    = "integrations/${aws_apigatewayv2_integration.colors_post.id}"
}

resource "aws_apigatewayv2_integration" "colors_get" {
  api_id                 = aws_apigatewayv2_api.example.id
  connection_type        = "INTERNET"
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.colors.invoke_arn
  passthrough_behavior   = "WHEN_NO_MATCH"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "colors_get" {
  api_id    = aws_apigatewayv2_api.example.id
  route_key = "GET /colors"
  target    = "integrations/${aws_apigatewayv2_integration.colors_get.id}"
}

resource "aws_apigatewayv2_route" "colors_get_by_id" {
  api_id    = aws_apigatewayv2_api.example.id
  route_key = "GET /colors/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.colors_get.id}"
}

resource "aws_apigatewayv2_api_mapping" "web" {
  api_id      = aws_apigatewayv2_api.example.id
  domain_name = aws_apigatewayv2_domain_name.web.id
  stage       = aws_apigatewayv2_stage.default.id
}
