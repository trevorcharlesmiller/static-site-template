
resource "aws_route53_record" "main-a-record" {
   zone_id = "${var.zone_id}"
   name = "${var.domain_name}"
   type = "A"
   alias {
    name = "${aws_s3_bucket_website_configuration.static-site-bucket-website.website_endpoint}"
    zone_id = "${aws_s3_bucket.static-site-bucket.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "main-c-name" {
  zone_id = "${var.zone_id}"
  name = "www.${var.domain_name}"
  type = "CNAME"
  ttl = "300"
  records = ["${var.domain_name}"]
}