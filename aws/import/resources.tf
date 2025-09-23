
import {
  to = aws_s3_bucket.terraform_state_bucket
  id = "nijipro-terraform"
}

import {
  to = aws_s3_bucket_versioning.terraform_state_bucket
  id = "nijipro-terraform"
}

import {
  to = aws_s3_bucket_server_side_encryption_configuration.terraform_state_bucket
  id = "nijipro-terraform"
}

resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "nijipro-terraform"

  tags = {
    Resource = "terraform"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_bucket" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }

}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_bucket" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

}
