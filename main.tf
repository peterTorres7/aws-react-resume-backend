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

resource "aws_s3_bucket" "peter_torres_website_bucket" {
  bucket = "peter-torres-website-bucket-test"
}
