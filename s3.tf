resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "bucket_public_access" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "bucket_policy" {
    bucket = aws_s3_bucket.website_bucket.bucket
    policy = data.aws_iam_policy_document.allow_access.json
}

data "aws_iam_policy_document" "allow_access" {
    statement {
        principals {
            type = "AWS"
            identifiers = ["*"]
        }
        actions = [
            "s3:GetObject",
        ]
        resources = [
            "${aws_s3_bucket.website_bucket.arn}/*",
        ]
    }
}
            "Resource": "arn:aws:s3:::petertorres.link/*"
resource "aws_s3_bucket_website_configuration" "website_bucket_config" {
  bucket = aws_s3_bucket.website_bucket.bucket

  index_document {
    suffix = "index.html"
  }
}
