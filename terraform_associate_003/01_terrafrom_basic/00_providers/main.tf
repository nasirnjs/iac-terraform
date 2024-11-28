terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"  # Specifies the provider source, which is the HashiCorp AWS provider in this case.
      version = "5.78.0"        # Specifies the version of the AWS provider to use.
    }
  }
}
provider "aws" {
  region = "us-east-1"  # Specifies the region in which AWS resources will be created.
}
