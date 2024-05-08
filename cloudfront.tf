locals {
    s3_origin_id = "${aws_s3_bucket.website_bucket.bucket}.s3-website-us-east-1.amazonaws.com"

}

resource "aws_cloudfront_distribution" "s3_distribution" {
    origin {
      domain_name = local.s3_origin_id #aws_s3_bucket.website_bucket.bucket_regional_domain_name
      origin_access_control_id = aws_cloudfront_origin_access_control.default.id
      origin_id = local.s3_origin_id
    }

    enabled = true
    is_ipv6_enabled = true
    default_root_object = "index.html"
    aliases = ["www.petertorres.link"]
    wait_for_deployment = true

    default_cache_behavior {
        allowed_methods = ["GET", "HEAD"]
        cached_methods = ["GET", "HEAD"]
        target_origin_id = local.s3_origin_id

        forwarded_values {
          query_string = false

          cookies {
            forward = "none"
          }
        }
        
        viewer_protocol_policy = "redirect-to-https"
        min_ttl = 1
        default_ttl = 86400
        max_ttl = 31536000
    }

    # price_class = "PriceClass200"

    restrictions {
        geo_restriction {
            restriction_type = "whitelist"
            locations = ["US", "CA", "GB", "DE"]
        }
    }

    viewer_certificate {
        cloudfront_default_certificate = true
        minimum_protocol_version = "TLSv1.2_2021"
        acm_certificate_arn = "arn:aws:acm:us-east-1:243481346369:certificate/a4108c08-5bfe-413e-b5a6-931388bdd390"
        ssl_support_method = "sni-only"
    }


}

resource "aws_cloudfront_origin_access_control" "default" {
  name = "s3-cloudfront-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}