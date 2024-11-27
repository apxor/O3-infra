/* aws acm ssl certificates */

module "nudg-apx-ozone-certificate" {
  source                    = "../tf-modules-generic/acm-certificate"
  domain_name               = "server.apxor.${var.root_domain}"
  subject_alternative_names = ["*.apxor.${var.root_domain}"]
  root_domain               = var.root_domain
}

output "nudg-apx-ozone-certificate-arn" {
  value       = module.nudg-apx-ozone-certificate.certificate_arn
  description = "arn of the certificate for prod environment for the domains server.apxor.ozonetel.com and *.apxor.ozonetel.com"
}
