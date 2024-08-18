
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

locals {
  name            = "lambda-apigateway-route53-${random_string.suffix.result}"
  web_domain_name = "web.${random_string.suffix.result}.${var.domain}"
}

data "template_file" "colors_mjs" {
  template = file("${path.module}/external/colors.mjs")
}

data "archive_file" "colors_mjs" {
  type        = "zip"
  output_path = "${path.module}/external/colors.zip"

  source {
    content  = data.template_file.colors_mjs.rendered
    filename = "index.mjs"
  }
}

output "http_apigateway_endpoint_url" {
  value = aws_apigatewayv2_api.example.api_endpoint
}

output "apigateway_colors_url" {
  value = "${aws_apigatewayv2_api.example.api_endpoint}/colors"
}

output "route53_colors_url" {
  value = "https://${aws_apigatewayv2_domain_name.web.domain_name}/colors"
}
