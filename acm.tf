resource "aws_acm_certificate" "web" {
  domain_name               = local.web_domain_name
  subject_alternative_names = [local.web_domain_name]
  validation_method         = "DNS"
}

resource "aws_acm_certificate_validation" "web" {
  certificate_arn = aws_acm_certificate.web.arn

  validation_record_fqdns = [
    for record in aws_route53_record.web_ssl_validation : record.fqdn
  ]

  depends_on = [
    aws_route53_record.web_ssl_validation
  ]
}
