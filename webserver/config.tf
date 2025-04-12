# Configure backend to store Terraform state in S3 bucket
terraform {
  backend "s3" {
    bucket  = "final-project-terraform-staging"
    key     = "webserver/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}