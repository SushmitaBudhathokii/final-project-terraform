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

module "webserver" {
  source              = "../modules/webserver"
  env                 = var.env
  key_name            = var.key_name
  default_tags        = var.default_tags
}