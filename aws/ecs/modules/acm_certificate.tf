data "aws_acm_certificate" "certificate" {
    domain = local.certificate_domain
}
