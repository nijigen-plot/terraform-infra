output "alb_log_bucket_name" {
    value = aws_s3_bucket.bucket.bucket
}

output "alb_log_bucket_arn" {
    value = aws_s3_bucket.bucket.arn
}

output "alb_log_bucket_id" {
    value = aws_s3_bucket.bucket.id
}
