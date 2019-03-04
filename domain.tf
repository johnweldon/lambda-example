resource "aws_acm_certificate" "exampleCert" {
  domain_name       = "${var.example_host}.${var.base_zone}"
  validation_method = "DNS"
}

data "aws_route53_zone" "exampleZone" {
  name         = "${var.base_zone}"
  private_zone = false
}

resource "aws_route53_record" "exampleSubdomain" {
  name    = "${aws_api_gateway_domain_name.exampleGatewayDN.domain_name}"
  zone_id = "${data.aws_route53_zone.exampleZone.id}"
  type    = "A"

  alias {
    evaluate_target_health = false

    name    = "${aws_api_gateway_domain_name.exampleGatewayDN.cloudfront_domain_name}"
    zone_id = "${aws_api_gateway_domain_name.exampleGatewayDN.cloudfront_zone_id}"
  }
}

resource "aws_route53_record" "exampleSubdomainValidation" {
  name    = "${aws_acm_certificate.exampleCert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.exampleCert.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.exampleZone.zone_id}"
  records = ["${aws_acm_certificate.exampleCert.domain_validation_options.0.resource_record_value}"]
  ttl     = "60"
}

resource "aws_acm_certificate_validation" "exampleSubdomainCert" {
  certificate_arn         = "${aws_acm_certificate.exampleCert.arn}"
  validation_record_fqdns = ["${aws_route53_record.exampleSubdomainValidation.fqdn}"]
}

output "custom_url" {
  value = "${aws_route53_record.exampleSubdomain.name}"
}
