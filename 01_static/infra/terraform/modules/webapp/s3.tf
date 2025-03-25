resource "aws_s3_bucket" "log" {
  bucket_prefix = "${var.project}-logs"
}

resource "aws_s3_bucket_public_access_block" "log" {
  bucket = aws_s3_bucket.log.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "log" {
  bucket = aws_s3_bucket.log.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "log" {
  bucket = aws_s3_bucket.log.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

data "aws_elb_service_account" "main" {}

data "aws_iam_policy_document" "allow_access_to_log" {
  statement {
    principals {
      type = "AWS"
      identifiers = [
        data.aws_elb_service_account.main.arn
      ]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = [
      aws_s3_bucket.log.arn,
      "${aws_s3_bucket.log.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "log" {
  bucket = aws_s3_bucket.log.bucket
  policy = data.aws_iam_policy_document.allow_access_to_log.json
}
