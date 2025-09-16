terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "aichatbotsamit-s3"
    key            = "terraform.tfstate"
    region         = "us-east-1"            # Static value here
    dynamodb_table = "aichatbot-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region   # Still fine here
}