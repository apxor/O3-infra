/* acm certificates module */

resource "aws_acm_certificate" "cert_acm" {
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
