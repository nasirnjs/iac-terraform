terraform {
  backend "s3" {
    bucket         = "mist-terraform-state-bucket"
    key            = "nasir-tf/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}