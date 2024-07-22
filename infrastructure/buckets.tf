resource "aws_s3_bucket" "static-site-bucket" {
  bucket = "${var.domain_name}"
}

resource "aws_s3_bucket" "static-site-www-bucket" {
  bucket = "www.${var.domain_name}"
}

resource "aws_s3_bucket_ownership_controls" "static-site-bucket-ownership" {
  bucket = aws_s3_bucket.static-site-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "static-site-bucket-public" {
  bucket = aws_s3_bucket.static-site-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "static-site-bucket-acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.static-site-bucket-ownership,
    aws_s3_bucket_public_access_block.static-site-bucket-public,
  ]

  bucket = aws_s3_bucket.static-site-bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_acl" "static-site-www-bucket-acl" {
  bucket = aws_s3_bucket.static-site-www-bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "static-site-bucket-website" {
  bucket = aws_s3_bucket.static-site-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_website_configuration" "static-site-www-bucket-website" {
  bucket = aws_s3_bucket.static-site-www-bucket.id
  redirect_all_requests_to {
    host_name = "${var.domain_name}"
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.static-site-bucket.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      aws_s3_bucket.static-site-bucket.arn,
      "${aws_s3_bucket.static-site-bucket.arn}/*",
    ]
  }
}