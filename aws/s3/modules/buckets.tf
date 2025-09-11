locals {
    s3_tags = merge(
        var.s3_additional_tags,
        {
            ServiceName = var.service_name
            Env = var.env
        }
    )
}

resource "aws_s3_bucket" "bucket" {
    bucket = "${var.prefix}-${var.service_name}-${var.env}"
    force_destroy = var.force_destroy
    tags = local.s3_tags
}

resource "aws_s3_bucket_versioning" "versioning_example" {
    bucket = aws_s3_bucket.bucket.id
    versioning_configuration {
    status = var.s3_bucket_versioning_status
    }
}
