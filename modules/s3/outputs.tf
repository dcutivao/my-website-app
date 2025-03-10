/*
output "bucket_arn" {
  description = "ARN del bucket S3"
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "Nombre de dominio del bucket S3"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "bucket_names" {
  value = aws_s3_bucket.this.bucket
} */

output "s3_website_url" {
  description = "URL del sitio web alojado en S3"
  value       = aws_s3_bucket_website_configuration.website_config.website_endpoint
}


output "bucket_names" {
  value = { for k, v in aws_s3_bucket.buckets : k => v.id }
}

output "all_bucket_arn" {
  value = [for bucket in aws_s3_bucket.buckets : bucket.arn]
}

output "all_bucket_id" {
  value = [for bucket in aws_s3_bucket.buckets : bucket.id]
}