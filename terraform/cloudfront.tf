locals {
  s3_origin_id = "cloud-resume.s3.us-east-1.amazonaws.com"
}

# Origin Access Control
resource "aws_cloudfront_origin_access_control" "resume_OAC" {
  name                              = "${aws_s3_bucket.resume_bucket.id}.s3.us-east-1.amazonaws.com"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "cloud_resume_distribution" {
  origin {
    domain_name              = aws_s3_bucket.resume_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.resume_OAC.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = var.default_root_object

  aliases = var.alternate_domain_alias

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.s3_origin_id
    cache_policy_id        = aws_cloudfront_cache_policy.cloud_resume_cache_policy.id
    viewer_protocol_policy = "redirect-to-https"

  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = var.cloud_resume_tag

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}

# Cache Policy
resource "aws_cloudfront_cache_policy" "cloud_resume_cache_policy" {
  name        = "Cloud-Resume-Cache-Policy"
  comment     = "Policy with caching enabled. Supports Gzip and Brotli compression."
  default_ttl = 86400
  max_ttl     = 31536000
  min_ttl     = 0
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip = true
  }
}

# DNS Record
resource "aws_route53_record" "resume" {
  zone_id = var.route53_zone_id
  name    = var.record_name_resume
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.cloud_resume_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.cloud_resume_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}