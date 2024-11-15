/* Outputs for the S3 bucket module */

output "bucket_name" {
  value = aws_s3_bucket.bucket.bucket
}
