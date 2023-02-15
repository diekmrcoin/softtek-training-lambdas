terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }
  backend "s3" {
    bucket = "softtek-tf-states"
    key    = "softtek-training-lambdas"
    region = "eu-west-3"
  }
  required_version = ">= 1.1.8"
}

provider "aws" {
  region = "eu-west-3"
  default_tags {
    tags = {
      Deploy  = "terraform"
      Project = "softtek-training-lambdas"
    }
  }
}
