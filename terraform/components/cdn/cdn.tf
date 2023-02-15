variable "prefix" { type = string }
variable "environment" { type = string }

output "cloudfront" {
  value = {
    domain_name = module.cloudfront.domain_name
  }
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "${var.prefix}-${var.environment}-oai-s3"
}

module "frontend_ui_bucket" {
  source                 = "../../modules/s3"
  environment            = var.environment
  prefix                 = var.prefix
  name                   = "frontend-ui"
  origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity
}

resource "aws_cloudfront_cache_policy" "cloudfront_cache_policy_s3" {
  comment     = "S3 cache policy for ${var.prefix}-${var.environment}"
  default_ttl = 1
  max_ttl     = 1
  min_ttl     = 1
  name        = "${var.prefix}-${var.environment}-cache-policy-s3"
  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "all"
    }
  }
}

resource "aws_cloudfront_cache_policy" "cloudfront_cache_policy_s3_media" {
  comment = "S3 cache policy for ${var.prefix}-${var.environment}"
  # 2 hours
  default_ttl = 7200
  # 2 days
  max_ttl = 172800
  # 5 minutes
  min_ttl = 300
  name    = "${var.prefix}-${var.environment}-cache-policy-s3-media"
  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "all"
    }
  }
}

module "cloudfront" {
  source                 = "../../modules/cloudfront"
  description            = "${var.prefix}-${var.environment}"
  environment            = var.environment
  origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity
  origins_s3_bucket      = [module.frontend_ui_bucket]
  origins_custom         = []
  origin_groups          = []

  default_cache_behavior = {
    cache_policy_id             = aws_cloudfront_cache_policy.cloudfront_cache_policy_s3.id
    origin_request_policy_id    = null
    response_headers_policy_id  = null
    target_origin_id            = module.frontend_ui_bucket.id
    lambda_function_association = []
    function_association        = []
  }

  error_response = {
    response_code      = 404
    response_page_path = "/404.html"
  }

  ordered_cache_behavior = [
    {
      allowed_methods             = ["GET", "HEAD", "OPTIONS"]
      cache_policy_id             = aws_cloudfront_cache_policy.cloudfront_cache_policy_s3_media.id
      origin_request_policy_id    = null
      path_pattern                = "/media/*"
      target_origin_id            = module.frontend_ui_bucket.id
      lambda_function_association = []
      function_association        = []
    }
  ]
}
