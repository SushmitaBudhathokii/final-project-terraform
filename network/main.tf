# Configure Terraform settings and AWS provider for the network module.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure AWS provider for us-east-1 region.
provider "aws" {
  region = "us-east-1"
}

module "network" {
  source              = "../modules/network"
  env                 = var.env
  vpc_cidr            = var.vpc_cidr
  public_cidr_blocks  = var.public_cidr_blocks
  private_cidr_blocks = var.private_cidr_blocks
  default_tags        = var.default_tags
}