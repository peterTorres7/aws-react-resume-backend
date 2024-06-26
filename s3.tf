resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
}

# resource "aws_s3_bucket_ownership_controls" "bucket_controls" {
#     bucket = aws_s3_bucket.website_bucket.id
#     rule {
#         object_ownership = "BucketOwnerEnforced"
#     }
# }

# resource "aws_s3_bucket_public_access_block" "bucket_public_access" {
#   bucket = aws_s3_bucket.website_bucket.id

#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }

resource "aws_s3_bucket_policy" "bucket_policy" {
    # depends_on = [
    #     aws_s3_bucket_ownership_controls.bucket_controls,
    #     aws_s3_bucket_public_access_block.bucket_public_access,
    # ]
    bucket = aws_s3_bucket.website_bucket.bucket
    policy = data.aws_iam_policy_document.allow_access.json
}

data "aws_iam_policy_document" "allow_access" {
    statement {
        principals {
            type = "Service"
            identifiers = ["cloudfront.amazonaws.com"]
        }
        actions = ["s3:GetObject"]
        resources = ["${aws_s3_bucket.website_bucket.arn}/*"]

        condition {
          test = "StringEquals"
          values = [aws_cloudfront_distribution.s3_distribution.arn]
          variable = "AWS:SourceArn"
        }
    }
}

# resource "aws_s3_bucket_website_configuration" "website_bucket_config" {
#   bucket = aws_s3_bucket.website_bucket.bucket

#   index_document {
#     suffix = "index.html"
#   }
# }

