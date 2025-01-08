terraform {
  required_providers {
    aws = {
      source  = "opentofu/aws"
      version = "5.66.0"
    }
  }
  backend "s3" {
    bucket = "gpu-state"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}
