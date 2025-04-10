# networkmodule/main.tf
# Configure Terraform settings and AWS provider for the network module.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}}

# Configure AWS provider for us-east-1 region.
provider "aws" {
  region = "us-east-1"
}

# Data source to get available availability zones in us-east-1 region.
data "aws_availability_zones" "available" {
  state = "available"
}

# Define tags locally
locals {
  default_tags = merge(var.default_tags, { "env" = var.env })
}