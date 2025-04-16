# Configure backend to store Terraform state in S3 bucket
terraform {
  backend "s3" {
    bucket  = "final-project-acs-s3"
    key     = "webserver/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
