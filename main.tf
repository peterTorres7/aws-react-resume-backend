terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "PeterTorres"

    workspaces {
      name = "aws-react-resume-backend"
    }
  }   

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

resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_website_configuration" "website_bucket_configuration" {
  bucket = aws_s3_bucket.website_bucket.bucket

  index_document {
    suffix = "index.html"
  }
}

