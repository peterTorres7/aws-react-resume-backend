terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 5.37.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket_website_configuration" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

}