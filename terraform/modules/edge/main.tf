# OAC 생성 -> CloudFront가 S3 버킷에 접근할 때 쓰는 인증서 
# CloudFront가 앞단에서 요청을 받고 정적 -> S3, API 요청 -> ALB로 
resource "aws_cloudfront_origin_access_control" "static" {
  name                              = "${var.name_prefix}-static-oac"
  description                       = "Origin access control for static S3 origin"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "this" {
  enabled         = true
  is_ipv6_enabled = true
  comment         = "${var.name_prefix} edge distribution"
  web_acl_id      = var.web_acl_arn

  origin {
    domain_name              = var.static_bucket_regional_domain_name
    origin_id                = "s3-static-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.static.id

    s3_origin_config {
      origin_access_identity = ""
    }
  }

  origin {
    domain_name = var.alb_dns_name
    origin_id   = "alb-api-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "s3-static-origin"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  ordered_cache_behavior {
    path_pattern           = "/api/*"
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "alb-api-origin"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = true
      headers      = ["*"]

      cookies {
        forward = "all"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-cloudfront"
  })
}

data "aws_iam_policy_document" "static_bucket_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${var.static_bucket_arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.this.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "static" {
  bucket = replace(var.static_bucket_arn, "arn:aws:s3:::", "")
  policy = data.aws_iam_policy_document.static_bucket_policy.json
}
