terraform {
  required_version = ">= 1.0"
  
  backend "s3" {
    # Backend configuration will be provided by the GitHub Action
    # bucket = "your-terraform-state-bucket"
    # key    = "path/to/terraform.tfstate"
    # region = "us-east-1"
    # encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

# Example resource
resource "aws_s3_bucket" "example" {
  bucket = "example-bucket-${var.environment}-${random_id.bucket_suffix.hex}"
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.example.bucket
}