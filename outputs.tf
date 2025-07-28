# =============================================================================
# TERRAFORM OUTPUTS
# =============================================================================

output "website_url" {
  value = "https://${aws_cloudfront_distribution.website.domain_name}"
}

output "source_bucket" {
  value = aws_s3_bucket.source.bucket
}

output "pipeline_name" {
  value = aws_codepipeline.website.name
} 