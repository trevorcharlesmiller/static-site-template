terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.8.0"
    }
  }

  required_version = ">= 1.5.3"
}

provider "aws" {
  profile = "default"
  region  = "ap-southeast-2"
}