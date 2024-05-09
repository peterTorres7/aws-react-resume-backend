resource "aws_route53_record" "wwww" {
  zone_id = local.hosted_zone_id
  name = "www.petertorres.link"
  type = "A"

  alias {
    name = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}