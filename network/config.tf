# Remote state S3 bucket
terraform {
  backend "s3" {
    bucket  = "final-project-terraform-staging3"
    key     = "network/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
