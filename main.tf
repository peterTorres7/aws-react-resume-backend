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

