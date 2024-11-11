/* variables for acm certificates module */

variable "root_domain" {
  type        = string
  description = "root domain name"
}

variable "domain_name" {
  type        = string
  description = "domain name"
}

variable "subject_alternative_names" {
  type = set(string)
}
